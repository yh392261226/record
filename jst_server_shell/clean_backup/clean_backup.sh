#!/bin/bash
################################################
### 清理往期备份
### Json 杨浩
### 2016-07-21
### 使用方法： crond  * 9 * * * * clean_backup.sh > /dev/null
################################################
BACKUPDIR=/data/backup 								#备份文件存放目录
CURDATE=$(date "+%Y-%m-%d") 						#当前日期
KEEPDAYS=7											#备份文件存留天数
CLEANDAY=$(date "+%Y-%m-%d" -d "$KEEPDAYS day ago")	#当前被清理日期

echo $CLEANDAY;
exit 1

if [ -d $BACKUPDIR ]; then
	files=$(ls $BACKUPDIR/| grep "${CLEANDAY}*")
	if [ "" != "$files" ]; then
		cd $BACKUPDIR
		for f in $files; do
			if [ -d $BACKUPDIR/$f ]; then
				/bin/rm -rf $BACKUPDIR/$f
			fi
		done
		exit 0
	else
		exit 1
	fi
else
	exit 1
fi
