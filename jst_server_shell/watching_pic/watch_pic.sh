#!/bin/bash
###################################################################
### 验证是否为图片文件 如果非图片文件则移入文件隔离区
###################################################################
#监听目录
inotify_path=/data/media/custom_product_photos/carvingtext
#隔离区路径
quarantinepath=/data/media/custom_product_photos/picture_action/quarantine
#实时监听命令位置
inotify_bin=/usr/local/bin/inotifywait
#守护进程脚本位置
pwatchdog=./pwatchdog.sh
#create新增 modify修改 delete删除 多个用,分割
inotify_type=create, modify
#忽略的要移动到隔离区的文件后缀列表
ignorelist=""
#移动到隔离区的前缀
prefix=carvingtext_

$inotify_bin -qmre $inotify_type $inotify_path --format '"%w" "%f" "%e"'| while read DIR FILENAME EVENT TIME;
do
  ##监听并操作
  ##########
  FILENAME=${FILENAME//\"/};
  DIR=${DIR//\"/};
  EVENT=${EVENT//\"/};

  curfiletype=$(/usr/bin/file $DIR/$FILENAME|awk -F':' '{print $2}'|awk -F',' '{print $1}' |awk '{print $2 " " $3 }')
  if [ "$curfiletype" != "image data" ]; then
    curext=$(echo $FILENAME |awk -F'.' '{print $2}')
    needdo="no"
    for tmpext in $ignorelist; do
      if [ "$tmpext" = "$curext" ] && [ "" != "$curext" ]; then
        needdo="yes"
      fi
    done
    if [ "$needdo" = "yes" ]; then
      /bin/mv $DIR/$FILENAME $quarantinepath/$prefix$(date "+%Y-%m-%d_%H_%M_%S")_$FILENAME
    fi
  fi
done
