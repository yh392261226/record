#!/bin/bash
####################################
# 发送负载过高报警
# Json杨浩
# 2016-05-17
####################################
RECEIVEURL=http://192.168.2.123/abc.php #接收地址
CURLBIN=/usr/bin/curl #curl命令地址
TOPLOG=/data/moritor_top/log #监控top值的日志地址
SENDLOG=/data/moritor_top/log #发送日志
CURDATE=$(date "+%Y-%m-%d")  #当前日期
LINE=22  #要打出的行数
LIMIT=10 #限制值
SERVER=web1

lastone=$(/usr/bin/tail -n $LINE $TOPLOG/${CURDATE}.log | grep 'load average:' |awk -F'load average:' '{print $2}'|awk -F',' '{print $1}')   #取得1分钟前的负载值
warn=$(echo "$LIMIT $lastone" |awk '{if ($1 >= $2) print "ok"; else print "trouble"}') #因为shell不支持浮点数比较 所以使用awk比较

if [ "$warn" = "trouble" ]; then
    echo $(date "+%H:%M:%S") $lastone >> $SENDLOG/${CURDATE}_send.log #记录发送日志
    $CURLBIN -s -d "server=$SERVER" -d "LEVEL=1" $RECEIVEURL #发送请求
fi
