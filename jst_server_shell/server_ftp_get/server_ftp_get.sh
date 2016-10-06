#!/bin/bash
######################################
### 服务器之间ftp文件
### 2016-07-15
### Json 杨浩
######################################
###配置文件块
inotify_path=/data/auto_ftp/log                   #监控的目录
inotify_bin=/usr/local/bin/inotifywait      	  #命令位置
inotify_type=create                         	  #监听状态
inotify_ext=do                           		  #监听文件后缀名
project_path=/data/								  #当前服务器项目目录
######################################

###FTP推送操作 每次操作单个文件
doFtp() {
	server=$1                         #源服务器
	file=$2                           #源文件
    serverport=$3                     #目标服务器ftp端口
    if [ "" = "$targetserverport" ]; then
        serverport=21
    fi
    user=$4                           #目标服务器ftp账号
    pass=$5                           #目标服务器ftp密码

    mkdir -p $project_path/$(dirname $file)
	ftp -n<<!
	open $server $serverport
	user $user $pass
	binary
	hash
    cd $(dirname $file)
    lcd $project_path/$(dirname $file)
	prompt
    mget $(basename $file)
	close
	bye
	!
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
        sourceserver=$(cat $DIR$FILENAME | grep 'sourceserver=' | cut -d '=' -f 2)
		action=$(cat $DIR$FILENAME | grep 'action=' | cut -d '=' -f 2)

        if [ "action" = "$action" ]; then                                 #执行验证
            if [ "" != "$sourceserver" ]; then                            #源服务器不能为空
	            sourcefiles=$(cat $DIR$FILENAME | grep 'sourcefiles=' | cut -d '=' -f 2)
	            if [ "" != "$sourcefiles" ]; then                         #源文件不能为空
	                if [ "" != "$(echo $sourcefiles | grep ',')" ]; then  #多个源文件的时候将源文件打散
	                    sourcefiles = $(echo $sourcefiles | sed "s/,/\n/g")
	                fi
		            #这里执行ftp操作

	            fi
			fi
        elif [ "history" = "$action" ]; then                              #执行历史查询
            searchdate=$(cat $DIR$FILENAME | grep 'searchdate=' | cut -d '=' -f 2)
            operatedate=$(cat $DIR$FILENAME | grep 'operatedate=' | cut -d '=' -f 2)
            #这里执行查询所有符合条件的记录

        fi
	fi
done
