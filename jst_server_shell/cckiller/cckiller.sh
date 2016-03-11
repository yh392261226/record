#!/bin/sh
###################################################################
#  CCKiller version 1.0.2 Author: Jager <ge@zhangge.net>          #
#  For more information please visit https://zhangge.net/5066.html #
#-----------------------------------------------------------------#
#  Copyright ©2015 zhangge.net. All rights reserved.              #
###################################################################

header()
{
        echo "CCKiller version 1.0.2 Author: Jager <ge@zhangge.net>"
        echo "Copyright ©2015 zhangge.net. All rights reserved. "
}

load_conf()
{
    CONF="/usr/local/cckiller/ck.conf"
    if [ -f "$CONF" ] && [ ! "$CONF" == "" ]; then
        source $CONF
        if [[ ! -z $IGNORE_PORT ]]
        then
            IGNORE_PORT=\:\($(echo $IGNORE_PORT|tr ',' '|')\)\|
        fi
    else
        header
        echo "$CONF not found."
        exit 1
    fi
}

showhelp()
{
	header
	echo
	echo 'Usage: cckiller [OPTIONS] [N]'
	echo 'N : number of tcp/udp	connections (default 100)'
	echo
	echo 'OPTIONS:'
	echo "-h | --help: Show	this help screen"
	echo "-k | --kill: Block the offending ip making more than N connections"
	echo '-s | --show: Show The TOP "N" Connections of System Current'
	echo "-b | --banip: Ban The IP or IP subnet like cckiller -b 192.168.1.1"
	echo "-u | --unban: Unban The IP or IP subnet which is in the BlackList of iptables"
	echo
}

banip()
{
    if [[ ! -z $1 ]]
    then
        /etc/init.d/iptables status | grep $1 >/dev/null
        if [[ 0 -ne $? ]]
        then
            $IPT -I INPUT -s $1 -j DROP && \
                echo "$1 Was Baned successfully."
                return 0
        else
            echo "$1 is already in iptables list, please check..."
            return 1
        fi
    else
        echo "Error: Not Found IP Address... Usage: cckiller -b IPaddress"
    fi
}

unbanip()
{

if [[ -z $1 ]]
then
UNBAN_SCRIPT=$(mktemp /tmp/unban.XXXXXXXX)
cat << EOF >$UNBAN_SCRIPT
#!/bin/sh
sleep $BAN_PERIOD
while read line
do
	$IPT -D INPUT -s \$line -j DROP
	#sed -i "/\$line/d" $IGNORE_IP_LIST

done < $BANNED_IP_LIST
rm -f $BANNED_IP_LIST $BANNED_IP_MAIL $BAD_IP_LIST $UNBAN_SCRIPT
EOF
. $UNBAN_SCRIPT &
else
    /etc/init.d/iptables status | grep $1 >/dev/null
    if [[ 0 -eq $? ]]
    then
        $IPT -D INPUT -s $1 -j DROP
        echo "$1 is Unbaned successfully."
    else
        echo "$1 is not found in iptables list, please check..."
    fi
fi
}

check_ip()
{
    
    #check_ip if in the $IGNORE_IP_LIST
    grep $CURR_LINE_IP $IGNORE_IP_LIST >/dev/null && return 0
    
    #check ip belongs to IP subnet
    result=$(awk -F'[./]' -v ip=$1 '
    {for (i=1;i<=int($NF/8);i++){a=a$i"."}
    if (index(ip, a)==1){split( ip, A, ".");if (A[4]<2^(8-$NF%8)) print "hit"} 
    a=""}' $IGNORE_IP_LIST )
    
    if [[ "$result" = "hit" ]]
    then
        return 0
    else
        return 1
    fi
    
}

show_stats()
{
	if [[ ! -z $1 ]] && [[ ! -z $2 ]]
	then
		netstat -ntu | \
        egrep -v "${IGNORE_PORT}LISTEN|127.0.0.1" | \
        awk -F"[ ]+|[:]" '{print $6}' | \
        sed -n '/[0-9]/p' | sort | uniq -c | sort -rn | head -$2
	else
		netstat -ntu | \
        egrep -v "${IGNORE_PORT}LISTEN|127.0.0.1" | \
        awk -F"[ ]+|[:]" '{print $6}' | \
        sed -n '/[0-9]/p' | sort | uniq -c | sort -rn
	fi
}

cc_check()
{
    TMP_PREFIX='/tmp/cckiller'
    TMP_FILE="mktemp $TMP_PREFIX.XXXXXXXX"
    BANNED_IP_MAIL=$($TMP_FILE)
    BANNED_IP_LIST=$($TMP_FILE)
    LOG_FILE=$LOGDIR/cckiller_$(date +%Y-%m-%d).log
    echo "Banned the following ip addresses on `date`" > $BANNED_IP_MAIL
    /etc/init.d/iptables status >/dev/null || /etc/init.d/iptables start >/dev/null
    echo >>	$BANNED_IP_MAIL
    BAD_IP_LIST=$($TMP_FILE)
    show_stats | awk -v str=$NO_OF_CONNECTIONS '{if ($1>=str){print $0}}' > $BAD_IP_LIST
	IP_BAN_NOW=0
	while read line; do
		CURR_LINE_CONN=$(echo $line | cut -d" " -f1)
		CURR_LINE_IP=$(echo $line | cut -d" " -f2)
		
# 		IGNORE_BAN=$(grep -c $CURR_LINE_IP $IGNORE_IP_LIST)

        check_ip $CURR_LINE_IP
        
        if [ $? -eq 0 ]; then
			continue
 		fi
  		
# 		grep $CURR_LINE_IP $IGNORE_IP_LIST >/dev/null && continue
# 		if [ $IGNORE_BAN -ge 1 ]; then
# 			continue
# 		fi
		IP_BAN_NOW=1
		
		banip $CURR_LINE_IP
		if [ $? -eq 1 ]; then
			continue
		fi
		
		echo "[`date "+%Y-%m-%d %H:%M:%S"`]: Banned $CURR_LINE_IP with $CURR_LINE_CONN connections" | tee -ai $LOG_FILE >> $BANNED_IP_MAIL
		echo $CURR_LINE_IP >> $BANNED_IP_LIST
		#echo $CURR_LINE_IP >> $IGNORE_IP_LIST

	done < $BAD_IP_LIST
	if [[ $IP_BAN_NOW -eq 1 ]]; then
		dt=$(date)
		if [[ $EMAIL_TO != "" ]] && [[ $EMAIL_TO != "root@localhost" ]]; then
			cat $BANNED_IP_MAIL | mailx -s "IP addresses banned on $dt" $EMAIL_TO
		fi
		unbanip
	else
		rm -f $BANNED_IP_LIST $BANNED_IP_MAIL $BAD_IP_LIST 
	fi
}

process_mode()
{
    while true
    do
        cc_check
        sleep $1
    done
}

#kill now
check_now()
{
    if [[ ! -z $1 ]]
    then
        NO_OF_CONNECTIONS=$1
    fi
    cc_check
}

load_conf
while [ $1 ]; do
	case $1 in
		'-h' | '--help' | '?' )
			showhelp
			exit
			;;
		'--kill' | '-k' )
			check_now $2
			;;
		'--show' | '-s')
		    show_stats show $2
		    break;
		    ;;
		 '--banip' | '-b' )
		    banip $2
		    break
			;;   
		 '--unban' | '-u' )
		    unbanip $2
		    break
			;;	
		 '--process' | '-p' )
		    process_mode $SLEEP_TIME
		    break
			;;
		*[0-9]* )
			check_now $1
			;;
		* )
		    showhelp
		    exit
			;;
	esac
	shift
done
[[ -z $1 ]] && show_stats
