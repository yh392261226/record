#!/bin/bash
#执行脚本tools.sh的位置
toolsbin=/root/json_packages/shelltest/tools.sh  #测试
#守护进程日志  记录重启次数
watchdoglog=/root/json_packages/shelltest/logs/twatchdog_log_  #测试

watching() {
    command=$1
    while [ 1=1  ]; do
        checkprocess=$(ps -ef| grep $(basename $toolsbin)| grep -v grep| grep -v vi|wc -l)
        if [ "$checkprocess" -lt "2" ]; then
            echo "$(date +%Y%m%d_%H:%M:%S) restart"  >> $watchdoglog$(date +%Y%m%d)
            $toolsbin normal $command >> /dev/null &
        fi
        sleep 1 #睡一秒 检测一次 如果量不是很大的时候  这个值可以设置稍微大一点 比如说 3 .... （我也挺无语，只能这样了）
    done
}


if [ "" = "$1" ]; then
    tput clear
    tput cup 3 15
    tput setaf 3
    echo "守护进程模式:"
    tput sgr0
    tput cup 5 15
    echo "4. 监听目录并记录日志"
    tput cup 6 15
    echo "5. 监听目录并压缩图片"
    tput cup 7 15
    echo "6. 监听目录并同步"
    tput cup 8 15
    echo "7. 监听目录,压缩图片,同步压缩后的图片并记录步骤日志"
    tput cup 9 15
    echo "Usage: $(dirname $0)/twatchdog.sh {4|5|6|7}"
    tput cup 10 15
    echo "**********************************************************************************************"
    tput cup 11 15
    echo "*  要kill掉$(basename $toolsbin) 脚本，必须先kill掉守护进程(即本脚本),"
    tput cup 12 15
    echo "*  执行命令如下:"
    tput cup 13 15
    echo "**********************************************************************************************"
    tput cup 14 15
    echo "一：下面这个命令是用来清理进程中的$(basename $0) 进程的"
    tput cup 15 15
    echo "ps -ef|grep $(basename $0)| grep -v grep| grep -v vim| awk '{print \$2}'| xargs kill -9"
    tput cup 16 15
    echo "二：下面这个命令是用来清理进程中的执行脚本$(basename $toolsbin) 进程的"
    tput cup 17 15
    echo "ps -ef|grep $(basename $toolsbin)| grep -v grep| grep -v vim| awk '{print \$2}'| xargs kill -9"
    tput cup 18 15
    echo "**********************************************************************************************"
    tput cup 19 15
    echo "只压缩并每日打包的话除了使用当前脚本的5 外还得在crontab里增加"
    
    if [ "$(ps -ef|grep $(basename $toolsbin)|grep -v grep|grep -v vim|wc -l)" -gt "1" ]; then
        tput cup 21 15
        echo "**********************************************************************************************"
        tput cup 22 15
        echo "#当前$(basename $toolsbin)脚本已运行"
        if [ "$(ps -ef|grep $(basename $0)|grep -v grep|grep -v vim|wc -l)" -lt "3" ]; then
            tput cup 23 15
            echo "#守护进程$(basename $0)未启动"
        else
            tput cup 23 15
            echo "#守护进程$(basename $0)已启动并守护"
        fi
        tput cup 24 15
        echo "**********************************************************************************************"
    fi
    tput bold
    tput cup 20 15
    echo "5 8 * * * $toolsbin normal 3 源目录/\$(date +%Y%m%d -d yesterday)  目标目录/\$(date +%Y%m%d -d yesterday).tar.gz"
    tput sgr0
    tput rc
else
    watching $1
fi




