#!/bin/bash
#####################################################
# 利用md5值监控文件变化
# 每次执行 生成一个当前日期的MD5记录集
# 使用方法： crontab
#        * * */1 * *  /data/wwwroot/jst_server_shell/web_watch/watching_file.sh > /dev/null &
#####################################################
old_md5_record=old_file_md5 #md5的记录
new_md5_record=new_file_md5 #新的md5的记录
operate_path=/data/project #操作目录
log_path=/jst_server_shell/web_watch/md5_log #日志目录
operate_date=$(date "+%Y-%m-%d") #操作日期
operate_time=$(date "+%H_%M_%S") #操作时间
result_log=${operate_date}_${operate_time}_result.log #操作结果集
##忽略目录是media和var

if [ ! -d $operate_path ]; then
   echo "$operate_path does not exists !";
   exit 1;
fi

if [ -f $log_path/$result_log ]; then
   mv $log_path/$result_log $log_path/${result_log}_${operate_date}_${operate_time};
fi

if [ ! -f $log_path/$old_md5_record ]; then
   find $operate_path -type f ! -path "$operate_path/var/*" ! -path "$operate_path/media/*" | xargs md5sum > $log_path/$old_md5_record;
   echo ${operate_date} ${operate_time} >> $log_path/$old_md5_record
fi

if [ ! -f $log_path/${operate_date}_${operate_time}_$new_md5_record ]; then
   find $operate_path -type f ! -path "$operate_path/var/*" ! -path "$operate_path/media/*" | xargs md5sum > $log_path/${operate_date}_${operate_time}_$new_md5_record;
else
   mv $log_path/${operate_date}_${operate_time}_$new_md5_record $log_path/${operate_date}_${operate_time}_$new_md5_record_${operate_date}_${operate_time}
   find $operate_path -type f ! -path "$operate_path/var/*" ! -path "$operate_path/media/*" | xargs md5sum > $log_path/${operate_date}_${operate_time}_$new_md5_record;
fi

if [ "" = "$(head $log_path/${operate_date}_${operate_time}_$new_md5_record)" ] || [ "" = "$(head $log_path/$old_md5_record)" ]; then
   echo "$log_path/${operate_date}_${operate_time}_$new_md5_record or $log_path/$old_md5_record is empty!";
   exit 1;
fi

/usr/bin/diff -w $log_path/${operate_date}_${operate_time}_$new_md5_record $log_path/$old_md5_record | grep "< "|sed 's,< ,,g' > $log_path/$result_log
echo "Please check $log_path/$result_log to view the diffrent!";
