#!/bin/bash
############################################################
## 监控~/.ssh/目录的公钥和私钥文件 防止被外力改变
## Json-杨浩
## 2016-02-02
## 使用方法 先将/root/.ssh/下的authorized_keys和id_rsa.pub文件复制到当前配置文件的路径里 
## 然后将 crontab里增加 0 */1 nohup 当前脚本 > /dev/null &
############################################################

keeping_pub=/jst_server_shell/keep_pub/id_rsa.pub
keeping_authorized=/jst_server_shell/keep_pub/authorized_keys
watching_pub=/root/.ssh/id_rsa.pub
watching_authorized=/root/.ssh/authorized_keys
log=/var/log/watching_ssh/

if [ "$(cat $keeping_pub)" != "$(cat $watching_pub)" ]; then
	rm -f $watching_pub
	cp $keeping_pub $watching_pub
	echo $(date "+%Y%m%d %H:%M:%S") 'id_rsa.pub' >> $log$(date "+%Y%m%d %H:%M:%S").log
fi

if [ "$(cat $keeping_authorized)" != "$(cat $watching_authorized)" ]; then
	rm -f $watching_authorized
	cp $keeping_authorized $watching_authorized
	echo $(date "+%Y%m%d %H:%M:%S") 'authorized_keys' >> $log$(date "+%Y%m%d %H:%M:%S").log
fi
