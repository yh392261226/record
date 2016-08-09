#!/bin/bash
SIZELIMIT=10000k   #文件大小限制 即查找10000k以上的文件
PATH=/             #查找路径

if [ "" != "$1" ]; then
  PATH=$1
fi

if [ "" != "$2" ]; then
  SIZELIMIT=$2
fi

find $PATH -size +$SIZELIMIT -print
