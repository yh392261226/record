#!/bin/bash
#
# 监听目录 根据新生成的文件内容来确定用户修改的文件都有哪些 并git push 这些文件
# 完成的会自动把.wait后缀名改成.finished
#
inotify_path=/www/watching_path                #监控的目录
inotify_bin=/usr/local/bin/inotifywait      						#命令位置
inotify_type=create                         						#监听状态
inotify_ext=wait                           							#监听文件后缀名
git_bin=/usr/bin/git                       							#git命令位置
curl_bin=/usr/bin/curl 												#curl命令位置
server=http://www.test.com/interface.php 								#server端的链接地址

##监听并操作
$inotify_bin -qmre $inotify_type $inotify_path --format '"%w" "%f" "%e"'| while read DIR FILENAME EVENT TIME;
do
    FILENAME=${FILENAME//\"/};
    DIR=${DIR//\"/};
    EVENT=${EVENT//\"/};
    EXT=${FILENAME##*.};
    if [ "$EXT" = "$inotify_ext" ]; then
		##获取到文件
        uname=$(cat $DIR$FILENAME | grep 'uname=' | cut -d '=' -f 2)
		filedir=$(cat $DIR$FILENAME | grep 'filedir=' | cut -d '=' -f 2)
		message=$(cat $DIR$FILENAME | grep 'commit=' | cut -d '=' -f 2)
		files=$(cat $DIR$FILENAME | grep 'files=' | cut -d '=' -f 2)
        action=$(cat $DIR$FILENAME | grep 'action=' | cut -d '=' -f 2)
		cd $filedir
		$git_bin $action $files
		$git_bin commit -m "$message"
		$git_bin push -u origin master
		if [ "$?" = "0" ]; then
			##发送php信号 给服务端
			finishname=$(echo $FILENAME | cut -d '.' -f 1)'.finished'
			mv $DIR$FILENAME $DIR$finishname
			$curl_bin -d 'uname='$uname -d 'filename='$(echo $FILENAME | cut -d '.' -f 1) $server
			echo "ok";
		fi
    fi
done
