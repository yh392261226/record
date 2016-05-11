#!/bin/bash
toolsbin=/data/auto_git/auto_git_client.sh
while [ 1=1  ]; do
    checkprocess=$(ps -ef| grep $(basename $toolsbin)| grep -v grep| grep -v vi| grep -v vim|wc -l)
    if [ "$checkprocess" -lt "2" ]; then
        $toolsbin >> /dev/null &
    fi
    sleep 1 #睡一秒 检测一次 如果量不是很大的时候  这个值可以设置稍微大一点 比如说 3 .... （我也挺无语，只能这样了）
done
