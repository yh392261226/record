#!/bin/bash
##################################################################
### 参照病毒库样本 分析监控目录
### 并记录日志 便于之后的分析
##################################################################
VIRUSDATA=./virus.dat           #病毒库
VIRUSDATAPATH=./virus_data      #病毒库源文件目录
LOGPATH=/log                    #日志地址
STARTLINE=2                     #病毒库开始行 默认前2行为注释


### json 分割
parse_json() {
  echo $1 | sed 's/.*'$2':[^,}]*.*/\1/'
}


### URL 分割
parse_url() {
  echo $1 | sed 's/.*'$2'=[[:alnum:]]∗.*/\1/'
}

tmpstartline=1
cat $VIRUSDATA | while read line; do
  if [ "$tmpstartline" -gt "$STARTLINE" ]; then
    echo "File:${line}"
  fi
  ((tmpstartline+=1))
done
