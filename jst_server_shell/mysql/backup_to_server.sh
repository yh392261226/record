#!/bin/bash
############################################
### 数据库及网站备份
### 备份数据并通过ftp传到其他服务器上
############################################


#数据库用户名
dbuser='root'
#数据库用密码
dbpasswd='rootpassword'
#需要备份的数据库，多个数据库用空格分开
dbname='database'
#要备份的网站地址
webbakpath='/data/wwwroot'
#备份时间
backtime=`date +%Y%m%d`
#删除备份的时间（保留7天）
deldate=` date -d -7day +%Y%m%d `
#数据备份路径
datapath='/home/bak/database'
#ftp地址
ftpserver='ftphost'
#ftp端口
ftpprot='ftpport'
#ftp用户名
ftpuser='ftpuser'
#ftp密码
ftppassword='ftppass'


#创建备份目录
mkdir -p $datapath
#正式备份数据库
for table in $dbname; do
source=`mysqldump -u ${dbuser} -p${dbpasswd} ${table}> ${datapath}/${backtime}.sql` 2>> ${datapath}/mysqllog.log;
#备份成功以下操作
if [ "$?" == 0 ];then
	cd $datapath
	#为节约硬盘空间，将数据库压缩
	tar jcf ${table}${backtime}.tar.bz2 ${backtime}.sql > /dev/null
	#同时压缩打包网站程序
	tar jcf ${table}web${backtime}.tar.bz2 ${webbakpath}/ > /dev/null
	#删除原始文件，只留压缩后文件
	rm -f ${datapath}/${backtime}.sql
	#删除七天前备份，也就是只保存7天内的备份
	find $datapath -name "*.tar.bz2" -type f -mtime +7 -exec rm -rf {} \; > /dev/null 2>&1
fi
done

#开始FTP上传
ftp -n<<!
open $ftpserver $ftpport
user $ftpuser $ftppassword
pass
binary
lcd $datapath
prompt
mput ${table}${backtime}.tar.bz2  ${table}${backtime}.tar.bz2
mput ${table}web${backtime}.tar.bz2  ${table}web${backtime}.tar.bz2
mdelete ${table}${deldate}.tar.bz2
mdelete ${table}web${deldate}.tar.bz2
close
bye !
