#!/bin/bash
#Json杨浩
tools_bin=/data/tools.sh

if [ -f $tools_bin ]; then
    . $tools_bin patch
else
    exit 1
fi

using_nfs_path=/data/everyday_ai/ #正式
ai_path=/data/ai/
endext=*
endname=.tar.gz
bak_prefix=bak_ai_

mkdir -p $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday)
if [ ! -d $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday) ]; then
    echo $(date +%H:%M:%S) "ai_patch_before_movefile" $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday) >> ${log_path}ai_patch_before_movefile_$(date "+%Y%m%d")
    exit 1
fi
for domove in $(ls $ai_path$(date "+%Y%m%d" -d yesterday)$endext); do
    mv $domove  $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday)/
done
cd $tmp_path
tar -zcvf $bak_prefix$(date "+%Y%m%d" -d yesterday).tar.gz  $bak_prefix$(date "+%Y%m%d" -d yesterday)

mv $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday)$endname  $using_nfs_path$(date "+%Y%m%d" -d yesterday)_web1_ai$endname
