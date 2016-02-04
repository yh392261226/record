#!/bin/bash
#web_watching.sh的位置
toolsbin=/jst_server_shell/web_watch/web_watching.sh
#守护进程日志  记录重启次数
watchdoglog=/jst_server_shell/web_watch/log/watchdog_log_  #测试

watching() {
    while [ 1=1  ]; do
        checkprocess=$(ps -ef| grep $(basename $toolsbin)| grep -v grep| grep -v vi|wc -l)
        if [ "$checkprocess" -lt "2" ]; then
            echo "$(date +%Y%m%d_%H:%M:%S) restart"  >> $watchdoglog$(date +%Y%m%d)
            $toolsbin dolog >> /dev/null &
        fi
        sleep 1 #睡一秒 检测一次 如果量不是很大的时候  这个值可以设置稍微大一点 比如说 3 .... （我也挺无语，只能这样了）
    done
}

watching