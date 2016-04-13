#!/bin/bash
#############################################
# 检查昨天或指定日期的top日志
#############################################
if [ "" != "$1" ]; then
	cur_date=$1
else
	cur_date=$(date +"%Y-%m-%d" -d yesterday)
fi

cat ./log/${cur_date}.log |grep 'load average' |less
