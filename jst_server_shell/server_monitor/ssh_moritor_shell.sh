#!/bin/bash
#
# 监听目录 根据新生成的文件后缀来确定是否开启ssh
# 完成的会自动把状态文件放到日志目录进行保存
#
inotify_path=/www/                                                  #监控的目录
inotify_bin=/usr/local/bin/inotifywait                              #命令位置
inotify_type=create                                                 #监听状态
inotify_ext1=.lock                                                  #监听文件后缀名
inotify_ext2=.unlock                                                #监听文件后缀名
finished_ext=.fin                                                   #完成后的后缀名
log_path=/www/ssh_lock/log                                          #日志目录

##监听并操作
$inotify_bin -qmre $inotify_type $inotify_path --format '"%w" "%f" "%e"'| while read DIR FILENAME EVENT TIME;
do
    FILENAME=${FILENAME//\"/};
    DIR=${DIR//\"/};
    EVENT=${EVENT//\"/};
    EXT=${FILENAME##*.};
    operateip=$(cat $DIR$FILENAME | grep -E -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}')
    if [ ".$EXT" = "$inotify_ext1" ]; then
        if [ "" = "$operateip" ]; then
            echo "sshd:all:deny" >> /etc/hosts.deny
        else
            echo "sshd:$operateip:deny" >> /etc/hosts.deny
        fi
        #向 sshd中 增加不可登录信息
        if [ "$?" = "0" ]; then
            finishname=$(date "+%Y-%m-%d_%H%M%S")_$(echo $FILENAME | cut -d '.' -f 1)$inotify_ext1$finished_ext
            mv $DIR$FILENAME $log_path/$finishname
        fi
    elif [ ".$EXT" = "$inotify_ext2" ]; then
        if [ "" = "$operateip" ]; then
            sed -i -e "/sshd:all:deny/ c\\
            " /etc/hosts.deny;
        else
            sed -i -e "/sshd:$operateip:deny/ c\\
            " /etc/hosts.deny
        fi
        #向 sshd中 剔除不可登录信息
        if [ "$?" = "0" ]; then
            finishname=$(date "+%Y-%m-%d_%H%M%S")_$(echo $FILENAME | cut -d '.' -f 1)$inotify_ext2$finished_ext
            mv $DIR$FILENAME $log_path/$finishname
        fi
    fi
done
