#!/bin/bash
##############################################################
##把服务器上日志里的ip访问次数及ip地址显示出来
##顺带增加了 该ip的地址来源  从ip138获取的
##方便排查问题##
##############################################################
logfile=$1          #log日志地址
minscore=100                         #最小访问次数
tmpfile=/tmp/tmp_today_ips.log        #临时日志文件位置

###先打出来一个临时的文件
cat $logfile | awk '{print $1}' | sort | uniq -c | sort -nr > $tmpfile
###解析
tmpcount=0
tmptimes=0
for i in $(cat $tmpfile); do
	if [ "$tmpcount" -eq "0" ] && [ "$i" -ge "$minscore" ]; then
		tmptimes=$i
	elif [ "$tmpcount" -eq "1" ] && [ "$tmptimes" -ge "1" ]; then
		echo $tmptimes $i $(curl -s http://ip138.com/ips138.asp\?ip\=$i\&action\=2 |iconv -f gb2312 -t UTF-8|grep '<td align="center"><ul class="ul1"><li>'|awk '{print $3}'|awk -F'：' '{print $2}')
	fi

	tmpcount=`expr $tmpcount + 1`
	if [ "$tmpcount" -gt "1" ]; then
		tmpcount=0
		tmptimes=0
	fi
#    if [ "$i" -gt "$minscore" ]; then
#        countip=$(cat $tmpfile | grep $i)
#        curip=$(echo $countip | awk '{print $2}')
#        echo $countip $(curl -s http://ip138.com/ips138.asp\?ip\=$curip\&action\=2 |iconv -f gb2312 -t UTF-8|grep '<td align="center"><ul class="ul1"><li>'|awk '{print $3}'|awk -F'：' '{print $2}')
#    fi
done
echo "以上ip需要检测，查看日志!"
rm -f $tmpfile
