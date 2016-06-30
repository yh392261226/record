#!/bin/bash
#############################################################
### 根据关键字查询备选后缀文件
#############################################################
WATCHING_PATH=/jst_server_shell/search_from_file/watching               #监控目录
LOG_PATH=/jst_server_shell/search_from_file/log                         #日志目录
WEXT=search                                                             #受监控的文件后缀名
RETURN_PATH=/jst_server_shell/search_from_file/returns                  #回显结果集目录
SEARCH_PATH=/project                                                    #要查询的目录
INOTIFY_TYPE=create                                                     #监控文件类型 为创建型
INOTIFY_BIN=/usr/local/bin/inotifywait                                  #监控命令位置
FIN_EXT=log                                                             #完成的后缀

#find $SEACH_PATH  -name "*$search_ext" -type f | xargs grep "$search_text" >> $RETURN_PATH/ 
###监听并操作
$inotify_bin -qmre $INOTIFY_TYPE $WATCHING_PATH --format '"%w" "%f" "%e"'| while read DIR FILENAME EVENT TIME;
do
    FILENAME=${FILENAME//\"/};
    DIR=${DIR//\"/};
    EVENT=${EVENT//\"/};
    EXT=${FILENAME##*.};
    
    if [ "$EXT" = "$WEXT" ]; then
        #符合规则 开始获取相应传递参数
        s_path=$(cat $DIR$FILENAME | grep 's_path=' | cut -d '=' -f 2)  #获取查询目录    与配置的查询目录联合 结果为${SEARCH_PATH}${s_path} 
		s_ext=$(cat $DIR$FILENAME | grep 's_ext=' | cut -d '=' -f 2)  #获取查询后缀    多个后缀名内容需要是a,b,c,d
        s_keywords=$(cat $DIR$FILENAME | grep 's_keywords=' | cut -d '=' -f 2)  #获取查询关键字
        s_returnfile=$(cat $DIR$FILENAME | grep 's_returnfile=' | cut -d '=' -f 2)  #获取回显文件名
        ###关键字与回显文件名不能为空
        if [ "$s_keywords" = "" ] || [ "$s_returnfile" = "" ]; then  
            #没有关键字或回显文件名 不查询
            mv $DIR/$FILENAME $LOG_PATH/${FILENAME}.$FIN_EXT   #先把落锁文件挪到日志文件夹下
            echo "没有关键字或回显文件名,不做查询!!!" >> $s_returnfile
            return 1
        fi
        ### 分割查询后缀 
        if [ "" != "$s_ext" ]; then
            s_ext=$(echo $s_ext | sed "s/,/ /g")
            if [ "" = "$s_ext" ]; then
                s_ext="*"
            fi
        else
            s_ext="*"
        fi

		for ex in $s_ext; do
            echo "/bin/find ${SEARCH_PATH}${s_path}  -name \"*$ex\" -type f | xargs /bin/grep \"$s_keywords\" >> $RETURN_PATH/${s_returnfile}" >> $RETURN_PATH/${s_returnfile}_command
        done

        if [ -f $RETURN_PATH/${s_returnfile}_command ]; then
            bash $RETURN_PATH/${s_returnfile}_command

            mv $DIR/$FILENAME $LOG_PATH/${FILENAME}.$FIN_EXT
            sed -i -e 's,$,<br>\r\n,' $RETURN_PATH/$s_returnfile
        fi
    fi
done
