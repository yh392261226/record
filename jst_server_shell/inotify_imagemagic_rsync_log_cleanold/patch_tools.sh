#!/bin/bash
##############################################################
# tools.sh的补丁脚本 
# 主要用于tools脚本压缩的前一天的图片 进行移动目录整理并打包
##############################################################
tools_bin=/root/json_packages/shelltest/tools.sh  #测试
#比对命令位置
diff_bin=/usr/bin/diff  #测试
#nfs 目录
using_nfs_path=/mnt/nfs/ #正式
#ai目录 这里使用了相对于监听目录的相对路径
ai_path=../ai/
#扩展名
endext=*
endname=.tar.gz
bak_prefix=bak_

if [ -f $tools_bin ]; then
    #引入tools.sh脚本
    . $tools_bin patch
else
    exit 1
fi

##删除文件
##$1 操作文件 或范域
##$2 是否使用for循环操作  文件过多使用
doremoveolds() {
    oldfiles=$1
    usefor=$2
    if [ "$usefor" = "true" ]; then
        for dofile in $(ls $oldfiles); do
            /bin/rm -rf $dofile
        done
    else
        /bin/rm -rf $oldfiles
    fi
}
##删除3天前的AI文件
doremoveolds $inotify_path$ai_path$(date "+%Y%m%d" -d '3 day ago')$endext  true
##删除3天前的源文件
doremoveolds $inotify_path$(date "+%Y%m%d" -d '3 day ago')$endext  true
##删除2天前的压缩图片文件夹
doremoveolds $tmp_path$bak_prefix$(date "+%Y%m%d" -d '2 day ago')  true
##删除2天前的压缩图片文件夹的压缩包
doremoveolds $tmp_path$bak_prefix$(date "+%Y%m%d" -d '2 day ago')$endname

##首先验证今天要操作的目标文件夹是否存在 不存在会自动创建 创建失败会自动退出的
docheckdir $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday)  true

if [ ! -d $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday) ]; then
    echo $(date +%H:%M:%S) "patch_before_movefile" $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday) >> ${log_path}patch_before_movefile_$(date "+%Y%m%d")
    exit 1
fi

##移动文件到要操作的目录
for domove in $(ls $tmp_path$(date "+%Y%m%d" -d yesterday)$endext); do
    domovefile $domove  $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday)/
done

##比对操作目录中的文件列表与源目录中的文件差异 对目标文件夹进行补救
needl=$tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday)/
ls $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday)/$endext|sed "s,${needl},,g" > /tmp/patch_diff1_$(date "+%Y%m%d" -d yesterday) #目标目录中的数据
ls $inotify_path$(date "+%Y%m%d" -d yesterday)$endext|sed "s,${inotify_path},,g" > /tmp/patch_diff2_$(date "+%Y%m%d" -d yesterday) #源目录中的数据
diffrent=$($diff_bin -w /tmp/patch_diff1_$(date "+%Y%m%d" -d yesterday)  /tmp/patch_diff2_$(date "+%Y%m%d" -d yesterday))
result=""
if [ "" != "$diffrent" ]; then
    result=$($diff_bin -w /tmp/patch_diff1_$(date "+%Y%m%d" -d yesterday)  /tmp/patch_diff2_$(date "+%Y%m%d" -d yesterday) | grep '> '| sed 's,> ,,g')
    for todofile in $result ; do
        if [ -f $inotify_path$todofile ] && [ ! -f $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday)/$todofile ]; then
            cp $inotify_path$todofile  $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday)/
        fi
    done
fi
##清理临时的比对文件
/bin/rm -f /tmp/patch_diff1_$(date "+%Y%m%d" -d yesterday) /tmp/patch_diff2_$(date "+%Y%m%d" -d yesterday)


##打包操作
cd $tmp_path
#下面这条 执行如果文件小可以  文件大 打包时间过长 后面的命令会执行  导致挪动的文件是空的 甚至直接就是目录
#docompresstotargz $bak_prefix$(date "+%Y%m%d" -d yesterday)  $bak_prefix$(date "+%Y%m%d" -d yesterday)
tar -zcvf $bak_prefix$(date "+%Y%m$d" -d yesterday)$endname  $bak_prefix$(date "+%Y%m%d" -d yesterday)

#移动压缩包到nfs目录
if [ ! -f $bak_prefix$(date "+%Y%m%d" -d yesterday)$endname ]; then
    echo $(date +%H:%M:%S) "patch_docompresstotargzfail" $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday)$endname >> ${log_path}patch_docompresstotargzfail_$(date "+%Y%m%d")
    exit 1
fi
domovefile $tmp_path$bak_prefix$(date "+%Y%m%d" -d yesterday)$endname  $using_nfs_path
sleep 10
exit 1
