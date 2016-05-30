#!/bin/bash
#################################
# ping域名组中的域名 是否正常
#################################
DOMAINS="www.baidu.com www.google.com"                            #域名组 多个域名之间用空格分隔
LOGFILE=/data/ping/status.log                                     #状态日志地址
PTIMES=4                                                          #ping的次数

echo $(date "+%Y-%m-%d %H:%M:%S") > $LOGFILE
for domain in $DOMAINS; do
	echo "域名："  $domain ", ping $PTIMES 次，丢包率：" $(ping -c $PTIMES $domain | grep 'transmitted' |awk -F',' '{print $3}'|awk -F'%' '{print $1}') "%" >> $LOGFILE
done

