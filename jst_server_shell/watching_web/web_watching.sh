#!/bin/bash
#************************************************************************#
##########################################################################
#*
#* inotify + log
#* 实时监控   日志
#* 实时监听网站根目录， 如果发生改变记录。
#* 配置参数如下:
#*
##########################################################################
#************************************************************************#

##目录设置【目录末尾都需要加上/】
#监控的目录 单目录监控 多目录过于耗费资源
inotify_path=/wwwroot/
#日志目录
log_path=/jst_server_shell/web_watch/log/

##命令位置【可以使用which 命令 获得命令所在位置】
#实时监听命令位置
inotify_bin=/usr/local/bin/inotifywait
#守护进程脚本位置
web_watchdog=/jst_server_shell/web_watch/web_watchdog.sh

##列表形式配置文件 【文件按行读取 所以每个扩展名都是独立的一行 如果是目录 必须以/结尾】
#忽略文件列表
excludelist=/jst_server_shell/web_watch/excludelist
#需要处理的文件后缀列表
dofilelist=/jst_server_shell/web_watch/dofilelist

#create新增 modify修改 delete删除 多个用,分割
inotify_type=create,modify,delete
#log记录开关 true开启
iflog=true

##验证文件是否需要处理
## $1 文件名
## 返回 0需要处理 1不需要处理
checkdoext() {
    checkext=$1
    for doext in $(cat $dofilelist); do
        if [ "$doext" = "$checkext" ]; then
            return 0
        fi
    done
    return 1
}

##验证文件是否在忽略列表
##返回1 不在 0在
checkexname() {
    checkname=$1
    for doext in $(cat $excludelist); do
        if [ "$(dirname $checkname)/" = "$doext" ] && [ -d "$doext" ]; then
            return 0
        fi
        if [ "$doext" = "$checkname" ]; then
            return 0
        fi
    done
    return 1
}

##监听并操作
## $1 命令 dolog监控目录并记录目录变化
##        dorsync监控目录并同步监控到的文件
##        doconvert监控目录并对图片进行压缩
##        order3监控目录 对图片进行压缩->同步->记录
## 无返回值
dowatching() {
    action=dolog

    $inotify_bin -qmre $inotify_type $inotify_path --format '"%w" "%f" "%e"'| while read DIR FILENAME EVENT TIME;
    do
        ##监听并操作
        ##########
        FILENAME=${FILENAME//\"/};
        DIR=${DIR//\"/};
        EVENT=${EVENT//\"/};
        EXT=${FILENAME##*.};
        #记录日志到当天的文件中
        if [ "$action" = "dolog" ]; then
            if [ "$iflog" = "true" ]; then
                #如果是删除目录   都记录
                if [ "$EVENT" = "DELETE,ISDIR" ]; then
                    echo $(date +%H:%M:%S) $EVENT $DIR$FILENAME >> ${log_path}$(date "+%Y%m%d").log
                fi

                #验证文件名
                checkexname $DIR$FILENAME
                if [ "$?" = "1" ]; then #在忽略列表中 跳过
                    #验证文件后缀名
                    checkdoext $EXT
                    if [ "$?" = "0" ]; then  #在操作列表中就记录
                        echo $(date +%H:%M:%S) $EVENT $DIR$FILENAME >> ${log_path}$(date "+%Y%m%d").log
                    fi
                fi
            fi
        fi
    done

}

action=$1
case "$action" in
    dolog)
        dowatching
        ;;
    *)
        echo "Usage $0 dolog"
        echo " 功能 $0 记录日志"
        ;;
esac
