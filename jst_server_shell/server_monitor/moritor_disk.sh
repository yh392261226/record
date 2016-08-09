#!/bin/bash
##############################################
### 监控硬盘使用情况
### 如果出现问题(空间到达限定值以内) 报警
##############################################
#最小值 10G
MINSIZE=1024000
#监控的盘符位置 多个 \/data\|\/dev
DISKNAMES="/data\|/boot"
#报警地址
RECEIVESERVER=http://127.0.0.1/receive.php
#curl命令地址
CURLBIN=/usr/local/bin/curl
#临时命令地址
COMMANDBIN=/tmp/checkdisk_command
#服务器标识名称
SERVERNAME="server1"

echo "/bin/df | grep \"${DISKNAMES}\" | awk '\$4 < "${MINSIZE}" {print \$6 \" \" \$4/1024/1024}'" > /tmp/checkdisk_command

trouble=""

if [ -f $COMMANDBIN ]; then
    /bin/chmod +x $COMMANDBIN
    trouble=$(/bin/bash $COMMANDBIN)
fi

if [ "" != "$trouble" ]; then
	#发送请求
    $CURLBIN -s -d "server=${SERVERNAME}" -d "level=3" $RECEIVESERVER  
fi
