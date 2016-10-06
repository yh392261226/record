#!/bin/bash
######################################
### 服务器之间ftp文件
### 2016-07-15
### Json 杨浩
######################################
###配置文件块
inotify_path=/data/auto_ftp/log                     #监控的目录
inotify_bin=/usr/local/bin/inotifywait      	    #命令位置
inotify_type=create                         	    #监听状态
inotify_ext=do                           		    #监听文件后缀名


######################################

###FTP推送操作 每次操作单个文件
doFtp() {
	server=$1                   //源服务器
    act=$2                      //操作方式get put
	file=$3                     //源文件
    serverport=$4               //目标服务器ftp端口
    if [ "" = "$targetserverport" ]; then
        serverport=21
    fi
    user=$5                     //目标服务器ftp账号
    pass=$6                     //目标服务器ftp密码

    if [ "put" = "$act" ]; then
    	ftp -n<<!
    	open $server $serverport
    	user $user $pass
    	binary
    	hash
        mkdir -p $(dirname $file)
        cd $(dirname $file)
        lcd $(dirname $file)
    	prompt
        mput $(basename $file)
    	close
    	bye
    	!
    else
        mkdir -p $(dirname $file)
    	ftp -n<<!
    	open $server $serverport
    	user $user $pass
    	binary
    	hash
        cd $(dirname $file)
        lcd $(dirname $file)
    	prompt
        mget $(basename $file)
    	close
    	bye
    	!

    fi
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
		action=$(cat $DIR$FILENAME | grep 'action=' | cut -d '=' -f 2)
        sourceserver=$(cat $DIR$FILENAME | grep 'sourceserver=' | cut -d '=' -f 2)
        targetserver=$(cat $DIR$FILENAME | grep 'targetserver=' | cut -d '=' -f 2)

        if [ "action" != "$action" ]; then //执行复制
            if [ "" = "$targetserver" ] || [ "" = "$sourceserver" ]; then
                exit 0
            fi
            sourcefiles=$(cat $DIR$FILENAME | grep 'sourcefiles=' | cut -d '=' -f 2)
            if [ "" != "$sourcefiles" ]; then
                if [ "" != "$(echo $sourcefiles | grep ',')" ]; then
                    sourcefiles = $(echo $sourcefiles | sed "s/,/\n/g")
                fi
            else
                exit 0
            fi
            //这里执行ftp操作

        elif [ "history" = "$action" ]; then //执行历史查询
            searchdate=$(cat $DIR$FILENAME | grep 'searchdate=' | cut -d '=' -f 2)
            operatedate=$(cat $DIR$FILENAME | grep 'operatedate=' | cut -d '=' -f 2)
            //这里执行查询所有符合条件的记录

        fi
	fi
done
