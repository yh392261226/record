#!/bin/bash
##############################################
### 根据日志内容监控php-fpm 是否有过多的拒绝
### 如果拒绝过多 就重启php-fpm (单个)
### crond
### */2 * * * * /jst_server_shell/watching_php-fpm/php-fpm.sh
##############################################
LOGFILE=/var/logs/nginx/logs/error.log                      #log地址
FPMBIN=php-fpm                                              #php-fpm地址
CURLBIN=/usr/bin/curl                                       #CURL命令地址
TAILBIN=/usr/bin/tail                                       #TAIL命令地址
RECEIVEURL=http://localhost.com/receive                     #报警接收url地址
READLINES=500                                               #每次打印条数
MAXTIMES=20                                                 #出现次数的界定值
KEYWORDS="connect() to unix:/dev/shm/php-cgi.sock failed"   #关键字
CURDATE=$(date "+%Y/%m/%d")                                 #当前日期
CURTIME=$(date "+%H:%M:%S")                                 #当前时间
BEFORETIME=$(date "+%H:%M:%S" -d "2 minutes ago")           #2分钟之前的时间
#LASTDOLOG=/jst_server_shell/watching_php-fpm/log/log_check_last_do_time                         #最近一次操作记录的日志最底行的时间
RECORDLOGPATH=/jst_server_shell/watching_php-fpm/log        #日志文件夹
SERVER=myserver                                             #服务器标识
LEVEL=3                                                     #报警等级

###{{{ 暂时废弃
###获取最后底行的时间的秒数
#lastlinetime=$(date -d $($TAILBIN -n 1 $LOGFILE | grep "$CURDATE" | awk '{print $2}') +%s)
###获取最近一次操作的时候记录的最底行的时间秒数
#lastdotime=$(cat $LASTDOLOG)

###将最近一次日志的最底行的时间记录
#echo $lastlinetime > $LASTDOLOG

###最底的时间的秒数小于等于上次操作时记录的时间秒数 则无新日志 退出脚本
#if [ "$lastlinetime" -le "$lastdotime" ]; then
#  exit 1
#fi
###}}}

###执行监听error log文件 判断是否需要操作
echo "$TAILBIN -n $READLINES $LOGFILE | grep \"$CURDATE\" | grep \"$KEYWORDS\" | awk '\$2 < \"$CURTIME\" && \$2 > \"$BEFORETIME\"' | wc -l" > $RECORDLOGPATH/lastcommand
chmod +x $RECORDLOGPATH/lastcommand
tmptimes=$(bash $RECORDLOGPATH/lastcommand)
if [ "$tmptimes" -ge "$MAXTIMES" ]; then
  service $FPMBIN restart
  if [ "$?" = "0" ]; then
    tmp1="A"
  else
    tmp1="B"
  fi
  echo "restart at $(CURTIME) $FPMBIN : $tmp1 " >> $RECORDLOGPATH/$(date "+%Y-%m-%d").log

  if [ "$tmp1" != "A" ]; then
    $CURLBIN -s -d "server=$SERVER" -d "level=$LEVEL" $RECEIVEURL > /dev/null
  fi
fi
