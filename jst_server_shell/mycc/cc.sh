#!/bin/sh
LOGFILE=/data/wwwlogs/soufeel.com/http/access.log
TEMPDENYSEC=60  #禁止秒数
EXCLUDEIPS='127.0.0.1 192.168.1.1 192.168.1.2'  #排除的ip
IPS=`tail -n 1000 $LOGFILE | awk '{print $1}' | sort | uniq -c | sort -rn| awk '$1 > 300 {print $2}'`   #1000行内有300行都是这个ip就会禁止这个ip
recordlog=/data/http/attc.log   #记录日志
for ip in $IPS; do
	if [ "" != "$ip" ]; then
		for eip in $EXCLUDEIPS; do
			if [ "$eip" = "$ip" ]; then
				continue 1
			else
				#操作该ip
        echo $ip >> $recordlog
        #csf --tempdeny $ip $TEMPDENYSEC  #临时禁止该ip sec秒 
        iptables -I INPUT -s $ip -j DROP
        /etc/init.d/iptables save
			fi
		done
	fi
done
