#!/bin/bash
########################################################
### 因程序员不行，那就我来，采用最蠢的方法来限制，误杀在所难免
### 按照同一个ip访问同一个地址出现的次数限制 视为攻击
### 需要配合csf防火墙使用
### 开启方法： ./cc3.sh &
########################################################
ONCELINES=50   										#一次取的条数
MAXTIMES=5											#限定次数
LOGFILE=/usr/local/nginx/logs/soufeel.cn.access.log #日志地址
ATTCLOG=/data/cc/attc_cc3.log						#记录地址
TEMPDENYSEC=60										#封锁时间 (秒)
EXCLUDES="127.0.0.1\|192.168.1.168"					#忽略的ip地址

attcips=$(tail -n $ONCELINES $LOGFILE | grep -v "$EXCLUDES" | awk '{print $1" "$7}' | sort -nr | uniq -c | sort -nr | awk '$1 > '${MAXTIMES}' {print $2}' | uniq)
if [ "" != "$attcips" ]; then
       	for attcip in $attcips; do
       		if [ "" != "$attcip" ]; then
       			csf --tempdeny $attcip $TEMPDENYSEC
       			if [ "$?" = "0" ]; then
       				echo $(date "+%Y-%m-%d %H:%M:%S") $attcip >> $ATTCLOG
       			fi
       		fi
       	done
fi
