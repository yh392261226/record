#!/bin/bash
inotify_path=/data/tools/report/log                     #监控的目录
inotify_bin=/usr/local/bin/inotifywait      						#命令位置
inotify_type=create                         						#监听状态
#inotify_ext=rd                           							#监听文件后缀名
report_path=/data/wwwroot/report                   			#report错误文件目录



##监听并操作
$inotify_bin -qmre $inotify_type $inotify_path --format '"%w" "%f" "%e"'| while read DIR FILENAME EVENT TIME;
do
    FILENAME=${FILENAME//\"/};
    DIR=${DIR//\"/};
    #EVENT=${EVENT//\"/};
    #EXT=${FILENAME##*.};
    #if [ "$EXT" = "$inotify_ext" ]; then
        ##获取到文件内容
        logname=$(cat $DIR$FILENAME | grep 'logname=' | cut -d '=' -f 2)
		if [ "" != "$logname" ]; then
			cat $report_path/$logname > $DIR$FILENAME
		fi
    #fi
done
