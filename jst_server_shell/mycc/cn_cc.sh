#!/bin/sh
###################################################
# 定时监控日志 分析日志中新增如的固定时间数内的ip数量
#     如果该ip数量超过限定值 则将该ip判断为攻击，并
#     将该ip进行封锁
#   crontab -e
# */5 * * * * /data/cc/cn_cc.sh
###################################################
LOGFILE=/usr/access.log     #记录日志
TEMPDENYSEC=60                                          #临时禁止秒数 当封锁方式为csf临时封锁时使用
EXIP="127.0.0.1\|192.168.1.1"                           #忽略的ip地址
EXKEYWORDS=".jpg\|gif\|.css\|.js"                       #忽略的关键字
RECORDLOG=/data/cc/log                                  #结果集日志地址
BLOCKTYPE=2                                             #封锁方式1:iptables永久封锁  2:csf临时封锁  3:csf永久封锁
CURDATE=$(date "+%d/%b/%Y")                             #根据nginx日志的日期来规定今天的日期
CURTIME=$(date "+%H:%M:%S")                             #根据nginx日志的日期来规定当前的时间
ROLLBACKTIME=5                                          #单位分钟      单位分钟以前  根据crontab的时间相对应的 尽量让时间的误差值最小
SAMEMINUTETIMES=500                                     #访问次数      单位分钟内   出现最多不超过500次的访问  否则视为攻击


tmpbacktime=$(date "+%H:%M:%S" -d "$ROLLBACKTIME minutes ago")
cat $LOGFILE | grep "$CURDATE" | sed -n "/${tmpbacktime}/,/${CURTIME}/p" | awk '{print $1}' | grep -v "$EXIP" | grep -v "$EXKEYWORDS" | sort | uniq -c | sort -nr | awk '$1 > '${SAMEMINUTETIMES}' {print $2}' > ${RECORDLOG}/tmp_record.log
exit 1
for ip in $(cat ${RECORDLOG}/tmp_record.log); do
  case "$BLOCKTYPE"
    1)
      iptables -I INPUT -s $ip -j DROP
      ;;
    2)
      csf --tempdeny $ip $TEMPDENYSEC             #临时禁止该ip sec秒
      ;;
    3)
      csf -d $ip
      ;;
  esac
done

if [ "$BLOCKTYPE" = "1" ]; then
  /etc/init.d/iptables save
  service iptables restart
fi

