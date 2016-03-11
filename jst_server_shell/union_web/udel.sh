#!/bin/bash
###############################################
#
# 删除用户
#     并删除与用户添加时同步添加的家目录及mail
#
###############################################
if [ $# -ne 1 ]; then
	echo "Usage: $0 username";
	echo "It's better to backup the files before delete the user";
	exit 1
fi

###一次确认机会
echo "It's better to backup the files before delete the user";
echo "Confirm: y/n";
read act;
if [ "$act" = "n" ] || [ "$act" = "N" ] || [ "$act" = "no" ] || [ "$act" = "NO" ]; then
	exit 1
fi

###配置
mail_path=/var/spool/mail  										#mail目录
web_path=/data/wwwroot     										#网站目录 含有用户家目录及家目录下的网站根目录
log_path=/data/wwwlogs     										#日志目录
nginx_conf_path=/usr/local/openresty/nginx/conf/common/vhost    #nginx 配置文件位置
alias_ext=com 													#创建别名的后缀名

username=$1

###验证用户是否存在
if [ "$(cat /etc/passwd|grep $username)" = "" ]; then
	echo "No such user";
	exit 1
fi

###删除该用户及用户创建时的一些目录
userdel $username
rm -rf $web_path/$username
rm -rf $mail_path/$username
rm -rf $log_path/${username}.${alias_ext}
rm -rf $nginx_conf_path/${username}.${alias_ext}
