#!/bin/bash
##########################################################
###检查隐藏进程
##########################################################
LOGPATH=./   #日志地址

ps -ef | awk '{print }' | sort -n | uniq > $LOGPATH/first
ls /proc | sort -n | uniq > $LOGPATH/second

if [ -f $LOGPATH/first ] && [ -f $LOGPATH/second ]; then
  diff $LOGPATH/first $LOGPATH/second
fi
