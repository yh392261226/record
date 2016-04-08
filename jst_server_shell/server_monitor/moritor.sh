#!/bin/bash
########################################################################################
### 记录linux 用户登录/退出 及用户所有操作命令
######
###### 使用方法:
######
### 把该脚本的地址加入到~/.bashrc 或~/.profile里    . /tools/moritor.sh
### login_logout login 登录
### 把该脚本滴地址 加入到~/.bash_logout里           . /tools/moritor.sh
### login_logout logout 登出
########################################################################################
###login user time and usernname
curl_bin=/usr/bin/curl                                                        			#curl命令位置
receive_server=http://local.mytest.com/receive.php                              		#server端的链接地址
login_username=$USER                                                          			#登录用户名
login_datetime=$(date +"%Y-%m-%d %H:%M:%S")                                   			#登录时间
login_uid=$UID                                                                			#登录用户名
login_ip=$(w |awk '{print $3}'|grep -E -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}'|sort |uniq) 	#登录ip
exec_ip=$(who am i |grep -E -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}')                         #执行ip
server_ip=$(ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " ") 			#服务器ip
server_name=$(hostname)                                                       			#服务器名称
server_type=$(uname)                                                          			#系统类型
server_version=$(cat /etc/redhat-release)                                     			#系统版本
server_bit=$(file /sbin/init | awk '{print $3}')                              			#系统位数

#用户登录/退出信息发送
login_logout() {
	exec_command=$1
    $curl_bin -s -d "user=$login_username" -d "uid=$login_uid" -d "server_ip=$server_ip" -d "server_name=$server_name" -d "server_version=$server_version" -d "server_bit=$server_bit" -d "exec_ip=$login_ip" -d "login_datetime=$login_datetime" -d "exec_command=$exec_command"  $receive_server >> /dev/null
}

#每一条用户操作发送
export PROMPT_COMMAND='{ `history 1 | { read x cmd; $curl_bin -s -d "uid=$login_uid" -d "uname=$login_username" -d "server_ip=$server_ip" -d "server_name=$server_name" -d "exec_command=$cmd" -d "exec_ip=$exec_ip" -d "datetime=$login_datetime" $receive_server >> /dev/null  ; }`; }'  #用户上一条操作命令
