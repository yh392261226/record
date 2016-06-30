#!/bin/bash
#########################################################################
### 守护进程 监控狗 监控自动搜索脚本是否已经停止
#########################################################################

toolsbin=/jst_server_shell/auto_search/search.sh
#守护进程日志  记录重启次数
watchdoglog=/jst_server_shell/auto_search/log

watching() {
    while [ 1=1  ]; do
        checkprocess=$(ps -ef| grep $(basename $toolsbin)| grep -v grep| grep -v vi|wc -l)
        if [ "$checkprocess" -lt "2" ]; then
            echo "$(date +%Y%m%d_%H:%M:%S) restart"  >> $watchdoglog$(date +%Y%m%d)
            $toolsbin >> /dev/null &
        fi
        sleep 1 #睡一秒 检测一次 如果量不是很大的时候  这个值可以设置稍微大一点 比如说 3 .... （我也挺无语，只能这样了）
    done
}

watching
