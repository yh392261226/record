#/bin/bash
#######################################################################
# Json杨浩
# 创建分表 按月份的01-12 分12张表
# 为了方便未来扩展可以把table_ext 设定为_年份来按照年月区分
# 使用时 可以先./create_seprate_table.sh -h
#######################################################################
cur_date=$(date "+%Y-%m-%d")							#当前日期
mysql_bin=/usr/local/mysql/bin                          #mysql的bin路径
mysql_user="root"										#mysql账户
mysql_host="127.0.0.1"									#mysqlIP地址
mysql_port="3306"										#mysql端口
mysql_pass="123456"			            				#mysql密码
table_ext="_$(date '+%Y')"								#表名后缀 方便未来扩展 可以为空
database="my_db"	    								#数据库名
table="test"											#表名
ifdata="false"											#是否将原表数据导入分表   true导入 前提是原表中数据有一个字段是按照2010-03-11 12:00:00 这样的结果存储的 默认为false
column="indate"											#ifdata所需的字段名

if [ "$*" != "" ]; then
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		clear
		echo ""
		echo "Usage: $0 database table host port user pass ext ifdata"
		echo "使用方法：$0 数据库名 表名 IP 端口 用户名 密码 分表后缀 是否导入数据"
		echo "Example: $0 test sep 127.0.0.1 3306 root 123456 _2016 false"
		echo "例子解释: 数据库test中的表sep 分表12张 名称为sep_01_2016的样子 不将原表数据分散导入分表"
		exit 0
	fi
	if [ "$1" != "" ]; then
		database=$1
	fi
	if [ "$2" != "" ]; then
		table=$2
	fi
	if [ "$3" != "" ]; then
		mysql_host=$3
	fi
	if [ "$4" != "" ]; then
		mysql_port=$4
	fi
	if [ "$5" != "" ]; then
		mysql_user=$5
	fi
	if [ "$6" != "" ]; then
		mysql_pass=$6
	fi
	if [ "$7" != "" ]; then
		table_ext=$7
	fi
	if [ "$8" != "" ]; then
		ifdata=$8
	fi
fi

#神奇的mysql命令
mysql_command="use $database; create table if not exists ${table}_01$table_ext like ${table}; create table if not exists  ${table}_02$table_ext like ${table}; create table if not exists  ${table}_03$table_ext like ${table}; create table if not exists  ${table}_04$table_ext like ${table}; create table if not exists  ${table}_05$table_ext like ${table}; create table if not exists  ${table}_06$table_ext like ${table}; create table if not exists  ${table}_07$table_ext like ${table}; create table if not exists  ${table}_08$table_ext like ${table}; create table if not exists  ${table}_09$table_ext like ${table}; create table if not exists  ${table}_10$table_ext like ${table}; create table if not exists  ${table}_11$table_ext like ${table}; create table if not exists  ${table}_12$table_ext like ${table};"

if [ "$ifdata" = "true" ]; then
	mysql_command=${mysql_command}" insert into ${table}_01$table_ext select * from ${table} where ${column} like '%-01-%'; insert into ${table}_02$table_ext select * from ${table} where ${column} like '%-02-%'; insert into ${table}_03$table_ext select * from ${table} where ${column} like '%-03-%'; insert into ${table}_04$table_ext select * from ${table} where ${column} like '%-04-%'; insert into ${table}_05$table_ext select * from ${table} where ${column} like '%-05-%'; insert into ${table}_06$table_ext select * from ${table} where ${column} like '%-06-%'; insert into ${table}_07$table_ext select * from ${table} where ${column} like '%-07-%'; insert into ${table}_08$table_ext select * from ${table} where ${column} like '%-08-%'; insert into ${table}_09$table_ext select * from ${table} where ${column} like '%-09-%'; insert into ${table}_10$table_ext select * from ${table} where ${column} like '%-10-%'; insert into ${table}_11$table_ext select * from ${table} where ${column} like '%-11-%'; insert into ${table}_12$table_ext select * from ${table} where ${column} like '%-12-%';"
fi

#执行脚本
$mysql_bin/mysql -u$mysql_user -h$mysql_host -P$mysql_port -p"$mysql_pass" -e "$mysql_command"
#echo "$mysql_bin/mysql -u$mysql_user -h$mysql_host -P$mysql_port -p\"$mysql_pass\" -e \"$mysql_command\""
if [ "$?" = "0" ]; then
	echo "$cur_date : "
	echo "Created tables ${table}_01$table_ext to ${table}_12$table_ext";
	if [ "$ifdata" = "true" ]; then
		echo "And import datas from ${table} seprated to the tables ${table}_01$table_ext to ${table}_12$table_ext already"
	fi
fi
