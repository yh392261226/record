#!/bin/sh
###################################################
# 定时监控日志 分析日志中新增如的固定行数内的ip数量
#     如果该ip数量超过限定值 则将该ip判断为攻击，并
#     将该ip进行封锁
###################################################
#记录日志
LOGFILE=/data/access.log
#临时禁止秒数 当封锁方式为csf临时封锁时使用
TEMPDENYSEC=60
#每次扫描是基数
COUNTNUM=50000
#限制最大的出现次数
MAXNUM=40
#忽略的ip地址
EXIP="127.0.0.1\|192.168.1.1"
#验证的关键字
KEYWORDS="\"POST\|base64(\|eval(\|base64_decode("
EXKEYWORDS=".jpg\|gif\|.css\|index.php\|test"
#结果集日志
RECORDLOG=/data/att1c.log
#上一次执行时log中的时间
LASTLOG=/data/lasttime.log                                 #上一次执行时log中的时间
BLOCKTYPE=1                                                         #封锁方式1:iptables永久封锁  2:csf临时封锁  3:csf永久封锁
IPS=""

if [ "$(cat $LASTLOG)" != "$(tail -n 1 $LOGFILE | awk '{print $4}')" ]; then
  IPS=`tail -n ${COUNTNUM} ${LOGFILE} | grep "${KEYWORDS}" | grep -v "${EXKEYWORDS}" | awk '{print $1}' | sort | uniq -c | sort -rn |grep -v "${EXIP}" | awk '$1 > '${MAXNUM}' {print $2}'`
  ifsave=0  #标识量
  for ip in $IPS; do
  	if [ "" != "$ip" ]; then
	  #操作该ip
      echo $ip >> $RECORDLOG
      if [ "$BLOCKTYPE" = "1" ]; then
        iptables -I INPUT -s $ip -j DROP
      elif [ "$BLOCKTYPE" = "2" ]; then
        csf --tempdeny $ip $TEMPDENYSEC  #临时禁止该ip sec秒
      elif [ "$BLOCKTYPE" = "3" ]; then
        csf -d $ip #永久禁止该ip
      fi
      ifsave=1
  	fi
  done
  if [ "$ifsave" = "1" ]; then
    if [ "$BLOCKTYPE" = "2" ] || [ "$BLOCKTYPE" = "3" ]; then
      csf -r
    elif [ "$BLOCKTYPE" = "1" ]; then
      /etc/init.d/iptables save
      service iptables restart
    fi
  fi
  tail -n 1 $LOGFILE | awk '{print $4}' > $LASTLOG
fi
