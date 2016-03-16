#!/bin/bash
##############################################################
##把服务器上日志里的ip访问次数及ip地址显示出来  
##顺带增加了 该ip的地址来源  从ip138获取的
##方便排查问题##
##############################################################
logfile=/var/logs/access.log          #log日志地址
minscore=1000                         #最小访问次数
tmpfile=/tmp/tmp_today_ips.log        #临时日志文件位置

###先打出来一个临时的文件
cat $logfile | awk '{print $1}' | sort | uniq -c > $tmpfile
###解析
for i in $(cat $tmpfile | awk '{print $1}'); do
    if [ "$i" -gt "$minscore" ]; then
        countip=$(cat $tmpfile | grep $i)
        curip=$(echo $countip | awk '{print $2}')
        echo $countip $(curl -s http://ip138.com/ips138.asp\?ip\=$curip\&action\=2 |iconv -f gb2312 -t UTF-8|grep '<td align="center"><ul class="ul1"><li>'|awk '{print $3}'|awk -F'：' '{print $2}')
    fi
done
echo "以上ip需要检测，查看日志!"
rm -f $tmpfile
