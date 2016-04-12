#/bin/bash
#######################################################################
# 监控mysql的负载及 show processlist
# crontab -e
# */5 * * * * 脚本路径
#######################################################################
log_path=/www/jst_server_shell/moritor_mysql/log  #日志地址
cur_date=$(date "+%Y-%m-%d")
mysql_bin=/usr/local/mysql/bin/mysql              #mysql的bin路径
mysql_user=root
mysql_host=127.0.0.1
mysql_port=3306
mysql_pass="123456"
mysql_command="show status; show full processlist;"
$mysql_bin -u$mysql_user -h$mysql_host -P$mysql_port -p"$mysql_pass" -e "$mysql_command" >> $log_path/${cur_date}.log
