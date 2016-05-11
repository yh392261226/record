#!/bin/bash
#
# 监听目录 根据新生成的文件内容来确定开启ftp
# 完成的会自动把.do后缀名改成.done
#
inotify_path=/data/auto_ftp/log                   #监控的目录
inotify_bin=/usr/local/bin/inotifywait      						#命令位置
inotify_type=create                         						#监听状态
inotify_ext=do                           							#监听文件后缀名
cur_ipaddr=server2                                           #当前服务器的ip地址

##验证ftp是否开启
checkftpd() {
    service vsftpd status | grep 'pid' > /dev/null
    if [ "$?" = "0" ]; then
        return 0  #运行中
    fi
    return 1  #未运行
}

##监听并操作
$inotify_bin -qmre $inotify_type $inotify_path --format '"%w" "%f" "%e"'| while read DIR FILENAME EVENT TIME;
do
    FILENAME=${FILENAME//\"/};
    DIR=${DIR//\"/};
    EVENT=${EVENT//\"/};
    EXT=${FILENAME##*.};
    if [ "$EXT" = "$inotify_ext" ]; then
		##获取到文件
        uname=$(cat $DIR$FILENAME | grep 'username=' | cut -d '=' -f 2)
		server=$(cat $DIR$FILENAME | grep 'server=' | cut -d '=' -f 2)
		usetime=$(cat $DIR$FILENAME | grep 'usetime=' | cut -d '=' -f 2)
        if [ "$cur_ipaddr" = "$server" ]; then
            checkftpd
            if [ "$?" != "0" ]; then
                service vsftpd start > /dev/null
                #落地锁 伪心跳包
                echo $(date "+%Y-%m-%d %H:%M:%S" -d "$usetime seconds") > $inotify_path/lock
                sleep $usetime
                if [ "$(cat $inotify_path/lock)" = "$(date '+%Y-%m-%d %H:%M:%S')" ]; then
                    service vsftpd stop > /dev/null
                    echo "" > $inotify_path/lock
                fi
            fi
        else
            scp $DIR$FILENAME root@server1:$DIR$FILENAME
        fi
        #完成的操作
        mv $DIR$FILENAME $DIR${FILENAME}ne
    fi
done
