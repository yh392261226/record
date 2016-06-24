#!/bin/bash
##############################################
### 根据日志内容监控php-fpm 是否有过多的拒绝
### 如果拒绝过多 就重启php-fpm
### crond
### */10 * * * * /watching_php-fpm/php-fpm.sh
##############################################
LOGFILE=/usr/nginx/log/error.log                    #log地址
FPMBIN=php-fpm                                      #php-fpm地址
FPMBIN2=php-fpm2                                    #php-fpm2地址
FPMBIN3=php-fpm3                                    #php-fpm3地址
CURLBIN=/usr/bin/curl                               #CURL命令地址
TAILBIN=/usr/bin/tail                               #TAIL命令地址
RECEIVEURL=http://localhost.com/receive             #报警接收url地址
READLINES=1000                                      #每次打印条数
MAXTIMES=20                                         #出现次数的界定值
KEYWORDS="recv() failed (104: Connection reset by peer) while reading response header from upstream"  #关键字
CURDATE=$(date "+%Y/%m/%d")                         #当前日期
CURTIME=$(date "+%H:%M:%S")                         #当前时间
BEFORETIME=$(date "+%H:%M:%S" -d "10minutes ago")   #10分钟之前的时间
LASTDOLOG=/data/watching_php-fpm/log/log_check_last_do_time                         #最近一次操作记录的日志最底行的时间
RECORDLOGPATH=/data/watching_php-fpm/log                                            #日志文件夹
SERVER=taiwan
LEVEL=3

###获取最后底行的时间的秒数
lastlinetime=$(date -d $($TAILBIN -n 1 $LOGFILE | grep "$CURDATE" | awk '{print $2}') +%s)
###获取最近一次操作的时候记录的最底行的时间秒数
lastdotime=$(cat $LASTDOLOG)

###将最近一次日志的最底行的时间记录
#echo $lastlinetime > $LASTDOLOG

###最底的时间的秒数小于等于上次操作时记录的时间秒数 则无新日志 退出脚本
#if [ "$lastlinetime" -le "$lastdotime" ]; then
#  exit 1
#fi

###执行监听error log文件 判断是否需要操作
#tmptimes=$($TAILBIN -n $READLINES $LOGFILE | grep "$CURDATE" | grep "$KEYWORDS" | awk '$2>="$CURTIME" && $2<="$BEFORETIME"' |wc -l)
#tmptimes=`/usr/bin/tail -n 1000 $LOGFILE | grep "$CURDATE" | grep "$KEYWORDS" | awk '$2" <= $CURTIME && "'$2'" >= $BEFORETIME"' | wc -l`
echo "$TAILBIN -n 1000 $LOGFILE | grep \"$CURDATE\" | grep \"$KEYWORDS\" | awk '\$2 < \"$CURTIME\" && \$2 > \"$BEFORETIME\"' | wc -l" > $RECORDLOGPATH/lastcommand
chmod +x $RECORDLOGPATH/lastcommand
tmptimes=$(bash $RECORDLOGPATH/lastcommand)
if [ "$tmptimes" -ge "$MAXTIMES" ]; then
  service $FPMBIN restart
  if [ "$?" = "0" ]; then
    tmp1="A"
  else
    tmp1="B"
  fi
  service $FPMBIN2 restart
  if [ "$?" = "0" ]; then
    tmp2="AA"
  else
    tmp2="BB"
  fi
  service $FPMBIN3 restart
  if [ "$?" = "0" ]; then
    tmp3="AAA"
  else
    tmp3="BBB"
  fi
  echo "restart at $(CURTIME) $FPMBIN : $tmp1  $FPMBIN2 : $tmp2  $FPMBIN3 : $tmp3" >> $RECORDLOGPATH/$(date "+%Y-%m-%d").log

  if [ "$tmp1" != "A" ] || [ "$tmp2" != "AA" ] || [ "$tmp3" != "AAA" ]; then
    $CURLBIN -s -d "server=$SERVER" -d "level=$LEVEL" $RECEIVEURL > /dev/null
  fi
fi
