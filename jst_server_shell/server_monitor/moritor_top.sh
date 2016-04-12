#!/bin/bash
#############################################################################
# 按照固定时间 或秒数 监控服务器的负载情况
# crontab -e
# */5 * * * * 脚本目录 每5分钟执行一次
#############################################################################

log_path=/www/jst_server_shell/moritor_top/log    #日志存放路径
cur_date=$(date "+%Y-%m-%d")                      #当前日期
tmp_ext=.tmp                                      #临时文件后缀名
show_line=22                                      #显示多少行
if [ ! -f $log_path/tmp$tmp_ext ]; then
  /bin/touch $log_path/tmp$tmp_ext
fi
/usr/bin/top -b -n 1 >> $log_path/tmp$tmp_ext
/usr/bin/head -n $show_line $log_path/tmp$tmp_ext >> $log_path/${cur_date}.log
rm -f $log_path/tmp$tmp_ext


