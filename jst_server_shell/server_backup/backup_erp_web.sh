#!/bin/bash
###################################
### 备份网站
###################################
#网站目录
WEBROOT=/data/htdocs
#备份存放目录
BACKUPDIR=/data/web_backup
#忽略目录
EXCLUDEDIR=public
#当前日期
CURDATE=$(date "+%Y-%m-%d")


cd $WEBROOT
tar -zcvf merp_${CURDATE}.tar.gz  * --exclude=$EXCLUDEDIR
mkdir -p $BACKUPDIR/$CURDATE
mv merp_${CURDATE}.tar.gz $BACKUPDIR/$CURDATE/merp_${CURDATE}.tar.gz
