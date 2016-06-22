#!/bin/bash
######################################################
##crontab里 每半小时检测一次
######################################################
CODENAME=auto_ftp.sh																	#脚本名称
KEEPCODENAME=watchdog.sh															#守护进程脚本名称
CODEPATH=/jst_server_shell/auto_ftp			#脚本所在路径
LOGPATH=$CODEPATH/log																	#日志路径

###如果在1小时内存在这个文件就向下执行
if [ -f $LOGPATH/restart_$(date "+%Y-%m-%d-%H") ]; then
	if [ $(ps -ef | grep "$KEEPCODENAME" | grep -v "grep" | wc -l) -lt 1 ]; then
		cd $CODEPATH && ./$KEEPCODENAME > /dev/null &
	fi

	if [ $(ps -ef | grep "$CODENAME" | grep -v "grep" |wc -l) -lt 2 ]; then
		cd $CODEPATH && ./$CODENAME > /dev/null &
	else
		`ps -ef | grep "$CODENAME" | grep -v "grep" | awk '{print $2}' | xargs kill -9`
	fi
fi
