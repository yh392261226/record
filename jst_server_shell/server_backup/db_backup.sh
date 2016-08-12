#!/bin/bash
#######################################
## 备份数据库 并通过ftp发送到备份服务器
## crond
## 1 5,19 * * * 该脚本地址
## 每天的5:01/19:01执行
#######################################

CURDATE=$(date "+%Y-%m-%d_%H-%M-%S")
DATE_DIR=$(date "+%Y-%m-%d")
DBNAME="test"
DBHOST="127.0.0.1"
DBUSER="root"
DBPASS='123456'
MYSQLBIN=/usr/local/mysql/bin
BACKUPPATH=/data/db_backup
FTPIP=192.168.1.111
FTPPORT=21
FTPUSER=abc
FTPPASS=123456

$MYSQLBIN/mysqldump -h"$DBHOST" -u"$DBUSER" -p"$DBPASS" $DBNAME > $BACKUPPATH/${CURDATE}_${DBNAME}.sql
cd $BACKUPPATH
/bin/tar -zcvf ${CURDATE}_${DBNAME}.sql.tar.gz ${CURDATE}_${DBNAME}.sql
/bin/rm -f ${CURDATE}_${DBNAME}.sql

ftp -n<<!
open $FTPIP $FTPPORT
user $FTPUSER $FTPPASS
binary
hash
cd merp/database
mkdir ${DATE_DIR}
cd ${DATE_DIR}
lcd ${BACKUPPATH}
prompt
put ${CURDATE}_${DBNAME}.sql.tar.gz
close
bye
!

RMDATE=$(date "+%Y-%m-%d" -d "7 day ago")
for i in $(/bin/ls ${BACKUPPATH}/${RMDATE}*); do
	/bin/rm -f $i
done
