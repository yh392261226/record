#!/bin/bash
#####################################
# 统计昨天的pv数量及ip总和 日志
#####################################
visit_log_path=/data/jst_server_shell/count/visit_log
access_log=/data/http/access.log
logyestoday=$(date "+%d/%b/%Y" -d '1 day ago')
excludeips='127.0.0.1' #排除的ip 多个形式：'127.0.0.1\|192.168.1.1\|192.168.1.2'
yestoday=$(date "+%Y-%m-%d" -d '1 day ago')
log_files=$access_log

if [ -f ${access_log}-$(date "+%Y%m%d" -d '1 day ago') ]; then
  log_files="$log_files ${access_log}-$(date '+%Y%m%d' -d '1 day ago')"
fi

if [ -f ${access_log}-$(date "+%Y%m%d") ]; then
  log_files="$log_files ${access_log}-$(date '+%Y%m%d')"
fi

cat $log_files | grep -v "$excludeips" | grep "$logyestoday" | awk '{print $1}' | sort | uniq -c | sort -rn > $visit_log_path/${yestoday}.log
