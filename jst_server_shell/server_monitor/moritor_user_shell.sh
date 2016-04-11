#!/bin/bash
###login user time and usernname
curl_bin=/usr/bin/curl                                                        			#curl命令位置
receive_server=http://local.soufeel.com/receive.php                              		#server端的链接地址
login_username=$USER                                                          			#登录用户名
login_datetime=$(date +"%Y-%m-%d %H:%M:%S")                                   			#登录时间
login_uid=$UID                                                                			#登录用户名
login_ip=$(who am i|grep -E -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}') 	                    #登录ip
server_ip=$(ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " ") 			#服务器ip
server_name=$(hostname)                                                       			#服务器名称
server_type=$(uname)                                                          			#系统类型
server_version=$(cat /etc/redhat-release)                                     			#系统版本
server_bit=$(file /sbin/init | awk '{print $3}')                              			#系统位数

#用户登录/退出信息发送
login_logout() {
	exec_command=$1
    if [ "" != "$login_ip" ]; then
        $curl_bin -s -d "user=$login_username" -d "uid=$login_uid" -d "server_ip=$server_ip" -d "server_name=$server_name" -d "server_version=$server_version" -d "server_bit=$server_bit" -d "exec_ip=$login_ip" -d "login_datetime=$login_datetime" -d "exec_command=$exec_command"  $receive_server >> /dev/null
    fi
}
#把该脚本的地址加入到/etc/profile里
#login_logout login   #这条加入到 ~/.bashrc里即可
#login_logout logout  #这条加入到 ~/.bash_logout

#每一条用户操作发送
export PROMPT_COMMAND='{ `history 1 | { read x cmd; $curl_bin -s -d "uid=$login_uid" -d "uname=$login_username" -d "server_ip=$server_ip" -d "server_name=$server_name" -d "exec_command=$cmd" -d "exec_ip=$login_ip" -d "datetime=$login_datetime" $receive_server >> /dev/null  ; }`; }'  #用户上一条操作命令
