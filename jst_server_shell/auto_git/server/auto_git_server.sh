#!/bin/bash
# auto_git server端
# 监听目录 根据新生成的文件来git pull
# 完成后会自动将监听文件.wait后缀名改为.finished
#
inotify_path=/www/server_watching_path                              #监控的目录
inotify_bin=/usr/local/bin/inotifywait      						#命令位置
inotify_type=create                         						#监听状态
inotify_ext=wait                           							#监听文件后缀名
git_bin=/usr/bin/git                       							#git命令位置
web_path=/www/server_test  					                        #web目录
sleep_seconds=30 													#默认等待秒数 等的少了容易那边没提交完 默认可以给300秒
log_path=/www/log                                                   #日志路径

##监听并操作
$inotify_bin -qmre $inotify_type $inotify_path --format '"%w" "%f" "%e"'| while read DIR FILENAME EVENT TIME;
do
    FILENAME=${FILENAME//\"/};
    DIR=${DIR//\"/};
    EVENT=${EVENT//\"/};
    EXT=${FILENAME##*.};
    if [ "$EXT" = "$inotify_ext" ]; then
		##获取到文件
    cursleepseconds=$(cat $DIR$FILENAME | grep 'sleeptime=' | cur -d '=' -f 2)
    if [ "$cursleepseconds" -gt "1" ]; then
		  sleep_seconds=$[$cursleepseconds*60]
	  fi
		cd $web_path
		sleep $sleep_seconds
        $git_bin pull 2>&1 | tee $log_path/$(echo $FILENAME | cut -d '.' -f 1).log #将结果集打印到日志文件
		if [ "$?" = "0" ]; then
			finishname=$(echo $FILENAME | cut -d '.' -f 1)'.finished'
			mv $DIR$FILENAME $DIR$finishname
			echo "ok";
		fi
    fi
done
