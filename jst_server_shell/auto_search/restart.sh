#!/bin/bash
BIN=/jst_server_shell/auto_search/search.sh
echo $(ps -ef | grep $(basename $BIN) |grep -v grep |awk '{print $2}')
ps -ef | grep $(basename $BIN) |grep -v grep |awk '{print $2}'|xargs kill -9
echo $(ps -ef | grep $(basename $BIN) |grep -v grep |awk '{print $2}')
