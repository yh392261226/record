#!/bin/bash
################################################################
### 监控服务器上我的小脚本的脚本
###     方便每日服务器巡检
################################################################
#自动同步的lsyncd
lsyncdstatus=$(service lsyncd status | grep 'is running')
if [ "$lsyncdstatus" != "" ]; then
  echo "1:lsyncd status is OK ...";
else
  echo "1:lsyncd status is BAD ... need to Check"
fi
echo ".................."

#cckiller
cckillerstatus=$(service cckiller status | grep 'is running')
if [ "$cckillerstatus" != "" ]; then
  echo "2:cckiller status is OK ...";
else
  echo "2:cckiller status is BAD ... need to Check"
fi
echo ".................."

#ssh的公钥监控
sshwatching=$(ls -l /data/wwwroot/jst_server_shell/keep_pub/log/ |wc -l)
if [ "$sshwatching" -gt "1" ]; then
  echo "3:ssh watching is BAD ... need to Check"
else
  echo "3:ssh watching is OK ..."
fi
echo ".................."

#网站文件监控
webwatching=$(cat /data/wwwroot/jst_server_shell/web_watch/log/$(date "+%Y%m%d").log | wc -l)
if [ "$webwatching" -ne "2" ]; then
  echo "4:web watching is BAD ... need to Check"
else
  echo "4:web watching is OK ..."
fi
echo ".................."

#auto git 监控
autogitwatching=$(ps -ef|grep 'server_inotify.sh' | grep -v 'grep' | wc -l)
autogitwaits=$(ls /data/wwwroot/soufeel-com-project/jst_auto_git/server_watching_path/ | grep 'wait' | wc -l)
if [ "$autogitwatching" -ne "2" ] || [ "$autogitwaits" -ge "1" ]; then
  echo "5:auto git is BAD ... need to Check"
else
  echo "5:auto git is OK ..."
fi
echo ".................."

#auto ftp 监控
autoftpwatching=$(ps -ef|grep 'auto_ftp.sh' | grep -v 'grep' | wc -l)
if [ "$autogitwatching" -lt "2" ]; then
  echo "5:auto ftp is BAD ... need to Check"
else
  echo "5:auto ftp is OK ..."
fi
echo ".................."

#Disk status 监控
echo "6:Disk status"
df -h
echo ".................."

#Memery status 监控
echo "7:Memery status"
free -m
echo ".................."
