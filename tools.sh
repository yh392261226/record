#!/bin/bash
#************************************************************************#
##########################################################################
#*
#* inotify + rsync + convert + tar + log
#* 实时监控   同步文件  图片压缩   压缩   日志
#* 配置参数如下:
#*
##########################################################################
#************************************************************************#

##目录设置【目录末尾都需要加上/】
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#监控的目录 单目录监控 多目录过于耗费资源
inotify_path=/root/json_packages/shelltest/inotify_path/  #测试
#同步至目录
rsync_path=root@192.168.2.225:/root/json_packages/ #测试
#日志目录
log_path=/root/json_packages/shelltest/logs/ #测试
#隔离区目录
quarantinepath=/root/json_packages/shelltest/quarantine/ #测试
#临时目录
tmp_path=/root/json_packages/shelltest/tmp_path/ #测试
#记录的txt文本文件夹
text_path=/root/json_packages/shelltest/text/ #测试

##命令位置【可以使用which 命令 获得命令所在位置】
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#rsync命令位置
rsync_bin=/usr/bin/rsync
#实时监听命令位置
inotify_bin=/usr/local/bin/inotifywait
#获取图片信息命令位置
identify_bin=/usr/bin/identify
#压缩图片命令位置
convert_bin=/usr/bin/convert
#守护进程脚本位置
twatchdog=./twatchdog.sh

##列表形式配置文件 【文件按行读取 所以每个扩展名都是独立的一行 不需要.】
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#rsync的忽略文件列表
rsync_exclude=/root/json_packages/shelltest/rsync_exclude #测试
#需要处理的文件后缀列表
dofilelist=/root/json_packages/shelltest/dofilelist #测试
#忽略的要移动到隔离区的文件后缀列表
ignorelist=/root/json_packages/shelltest/ignorelist #测试
##参数设置【具体的参数 参考命令】
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#create新增 modify修改 delete删除 多个用,分割
inotify_type=create
#目标机ssh端口 默认22
#rsync_port=8792  #正式
rsync_port=22 #测试
#rsync 命令的参数  详情参考rsync命令的参数
rsync_para=cauz
#压缩图片限制的宽x高 如果图片比限定值小就保持原样， 避免小图放大 且当图片长或宽超过规定的尺寸。高度和宽度比例保留最低值 具体参考 convert命令
limitwh="600x600^>"
#压缩图片生成的后缀名   jpg是最小存贮尺寸 可以设置 old 即保留原有文件后缀
finished_ext=.jpg
#压缩时 目标文件存在 是否覆盖[true覆盖][false不覆盖并中断操作]  其他值不覆盖将以coverprefix目标文件名 重命名目标文件
covertargetfile=true
#目标文件存在的情况下 不覆盖将以coverprefix+目标文件名 重命名目标文件
coverprefix=2_
#log记录开关 true开启
iflog=true
#记录的txt文本文件后缀名
text_ext=.txt

##系统参数获得【具体的 参考命令】
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#当前日期
#curdate=$(date "+%Y%m%d")
#前一天的日期
#onedateago=$(date "+%Y%m%d" -d yesterday)

#************************************************************************#
##########################################################################
#*
#* inotify + rsync + convert + tar + log
#* 实时监控   同步文件  图片压缩   压缩   日志
#* 逻辑程序如下:
#*
##########################################################################
#************************************************************************#

##记录文本给别人用
## $1 内容 不能为空否则不记录
## $2 文件名 不存在会自动创建
## 返回0成功  1不成功
dorecordtotext() {
    content=$1
    textfile=$2
    if [ "" != "$content" ]; then
        echo $content >> $textfile
        return 0
    fi
    return 1
}

##同步
## $1 要同步的文件名
## 返回 0成功 1不成功
dosyncfile() {
    filename=$1 #要传输的文件名
    if [ ! -f $filename ]; then
        return 1
    fi
    $rsync_bin -$rsync_para --progress --exclude-from=$rsync_exclude -e "ssh -p $rsync_port" $filename $rsync_path
    
    if [ "$?" = "0" ]; then
        if [ "$iflog" = "true" ]; then
            echo $(date +%H:%M:%S) "dosyncfile" $filename >> ${log_path}dosyncfile_$(date "+%Y%m%d")
        fi
        return 0
    else
        if [ "$iflog" = "true" ]; then
            echo $(date +%H:%M:%S) "dosyncfilefail" $filename >> ${log_path}dosyncfilefail_$(date "+%Y%m%d")
        fi
        return 1
    fi
}

##获取文件类型
## $1 文件名
## 返回 0图片类型 或 1非图片类型
getimagetype() {
    if [ ! -f $1 ]; then
        return 1
    fi
    filename=$1 #要获取的文件名
    curfiletype=$(file -bi $filename| awk -F"; " '{print $1}'| awk -F"/" '{print $1}')
    if [ "image" != "$curfiletype" ]; then
        return 1
    fi
    return 0
}

##验证文件是否需要处理
## $1 文件名
## 返回 0需要处理 1不需要处理
checkdoext() {
    execfilelist=$1
    if [ ! -f $execfilelist ]; then
        return 1
    fi
    ext=$2
    for doext in $(cat $execfilelist); do
        if [ "$doext" = "$ext" ]; then
            return 0
        fi
    done
    return 1
}

##打包文件/目录 为.tar.gz格式
## $1 源文件
## $2 目标文件
## 返回 0成功 1失败
docompresstotargz() {
    sourcename=$1
    targetname=$2
    if [ ! -f $1 ] && [ ! -d $1 ]; then
        return 1
    fi
    endname=.tar.gz
    #目标文件存在的情况下 重命名目标文件
    if [ -f $targetname$endname ]; then
        targetname=$coverprefix$targetname
    fi
    
    tar -zcvf $targetname$endname $sourcename
    if [ "$?" = "0" ]; then
        if [ "$iflog" = "true" ]; then
            echo $(date +%H:%M:%S) "docompresstotargz"  $sourcename 》==》 $targetname$endname >> ${log_path}docompresstotargz_$(date "+%Y%m%d")
        fi
        return 0
    else
        if [ "$iflog" = "true" ]; then
            echo $(date +%H:%M:%S) "docompresstotargzfail" $sourcename 》==》 $targetname$endname >> ${log_path}docompresstotargz_$(date "+%Y%m%d")
        fi
        return 1
    fi
}

##守护进程方式启动[暂时废弃]
## $1 内部命令
## 无返回值
daemonprocess() {
    command=$1
    while [ 1=1 ]; do
        processcount=$(ps -ef|grep $(basename $0)|grep -v grep|wc -l)
        if [ "$processcount" -lt "1" ]; then
            case "$command" in
                dolog)
                    dowatching dolog >> /dev/null &
                ;;
                doconvert)
                    dowatching doconvert >> /dev/null &
                ;;
                dorsync)
                    dowatching dorsync >> /dev/null &
                ;;
                order3)
                    dowatching order3 >> /dev/null &
                ;;
            esac
        fi
        # 睡3秒一循环   持续一个进程
        sleep 3
    done
}

##获取图片的宽x高
## $1 图片名
## 返回 图片宽x高 1获取失败
getpicwh() {
    filename=$1
    if [ ! -f $filename ]; then
        return 1
    fi
    echo $($identify_bin $filename| cut -d ' ' -f 3)
    return 0
}

##压缩图片
## $1 源文件
## $2 目标文件  如果目标文件存在 根据配置文件判断是覆盖 跳过 或重命名 如果目标文件不给值 就操作源文件
## 返回0成功  1失败
doconvertpic() {
    filename=$1
    if [ ! -f $filename ]; then
        return 1
    fi
    #验证是不是图片文件 不是图片 验证文件后缀名
    filetype=$(getimagetype $filename)
    if [ "$?" != "0" ]; then
        #不是图片的日志
        echo $(date "+%H:%M:%S") "notpicture_docheckextindo" $filename >> ${log_path}docheckextindoext_$(date "+%Y%m%d")
        #验证是否在操作文件列表中   特殊情况下的
        checkdoext $(cat $dofilelist)  $(basename $filename|cut -d '.' -f 2)
        if [ "$?" = "1" ]; then
            #不在操作列表中日志
            echo $(date "+%H:%M:%S") "notindo" $filename >> ${log_path}docheckextinignoreext_$(date "+%Y%m%d")
            #验证是否在忽略文件列表中  忽略了就不移动到隔离区 如.html文件
            checkdoext $(cat $ignorelist)  $(basename $filename|cut -d '.' -f 2)
            if [ "$?" = "1" ]; then
                #移动到隔离区日志
                echo $(date "+%H:%M:%S") "notinignore" $filename >> ${log_path}docheckmove_$(date "+%Y%m%d")
                #不在忽略列表中 移动到隔离区
                domovefile $filename  $quarantinepath
                if [ "$?" = "1" ]; then
                    if [ "$iflog" = "true" ]; then
                        echo $(date +%H:%M:%S) "domovetoquarantinefail" $filename >> ${log_path}domovetoquarantine_$(date "+%Y%m%d")
                    fi
                else
                    if [ "$iflog" = "true" ]; then
                        echo $(date +%H:%M:%S) "domovetoquarantine" $filename >> ${log_path}domovetoquarantine_$(date "+%Y%m%d")
                    fi
                fi
                return 1
            fi
        fi
    fi
    
    targetfilename=$2
    #没有目标文件名 就直接覆盖源文件
    if [ "" = "$targetfilename" ]; then 
        targetfilename=$filename
    else
        #如果压缩成其他后缀名
        #if [ "$finished_ext" != "old" ]; then
        #    targetfilename=$(echo $targetfilename|cut -d '.' -f 1)$finished_ext
        #fi
        #目标文件存在
        if [ -f $targetfilename ]; then
            #目标文件存在重命名目标文件 否则覆盖
            if [ "$covertargetfile" != "true" ] && [ "$covertargetfile" != "false" ]; then
                targetfilename=$(dirname $targetfilename)/$coverprefix$(basename $targetfilename| cut -d '.' -f 1).$(basename $targetfilename| cut -d '.' -f 2)
            elif [ "$covertargetfile" = "false" ]; then
                if [ "$iflog" = "true" ]; then
                    echo $(date +%H:%M:%S) "doconvertpicfail" $filename 》==》 $targetfilename >> ${log_path}doconvertpic_$(date "+%Y%m%d")
                fi
                return 1
            fi
        fi
    fi
    $convert_bin -resize $limitwh $filename $targetfilename
    
    if [ "$?" = "0" ]; then
        if [ "$iflog" = "true" ]; then
            echo $(date +%H:%M:%S) "doconvertpic" $filename 》==》 $targetfilename >> ${log_path}doconvertpic_$(date "+%Y%m%d")
        fi
        echo $targetfilename
        return 0
    else
        if [ "$iflog" = "true" ]; then
            echo $(date +%H:%M:%S) "doconvertpicfail" $filename 》==》 $targetfilename >> ${log_path}doconvertpic_$(date "+%Y%m%d")
        fi
        return 1
    fi
}

##移动文件
## $1 源文件
## $2 目标文件 目标文件夹不存在就创建
## 返回 0成功 1失败
domovefile() {
    filename=$1
    targetfilepath=$2
    if [ ! -f $filename ] || [ "" = "$targetfilepath" ]; then
        if [ "$iflog" = "true" ]; then
            echo $(date +%H:%M:%S) "domovefilefail" $filename >> ${log_path}domovefile_$(date "+%Y%m%d")
        fi
        return 1
    else
        docheckdir $targetfilepath true
        if [ "$?" = "1" ]; then
            #目录不存在 且无法创建
            if [ "$iflog" = "true" ]; then
                echo $(date +%H:%M:%S) "domovefilefail" $filename >> ${log_path}domovefile_$(date "+%Y%m%d")
            fi
            return 1
        fi
    fi
    mv $filename $targetfilepath
    if [ "$?" = "1" ]; then
        if [ "$iflog" = "true" ]; then
            echo $(date +%H:%M:%S) "domovefilefail" $filename >> ${log_path}domovefile_$(date "+%Y%m%d")
        fi
        return 1
    else
        if [ "$iflog" = "true" ]; then
            echo $(date +%H:%M:%S) "domovefile" $filename >> ${log_path}domovefile_$(date "+%Y%m%d")
        fi
        return 0
    fi
}

##检验文件夹是否存在
## $1 文件夹地址 
## $2 是否创建 true创建 执行创建后会调用自身再检测一次 来确认是否创建成功
## 返回 0成功  1失败
docheckdir() {
    pathname=$1
    domk=$2 #如果值为 true 那么文件夹不存在就创建 
    if [ "" = "$pathname" ]; then
        return 1
    fi
    if [ ! -d $pathname ]; then
        if [ "true" = "$domk" ]; then
            mkdir -p $pathname
            docheckdir $pathname #创建后再检测一次  避免无权限创建不成功
        fi
        return 1
    fi
    return 0
}

##监听并操作
## $1 命令 dolog监控目录并记录目录变化
##        dorsync监控目录并同步监控到的文件
##        doconvert监控目录并对图片进行压缩
##        order3监控目录 对图片进行压缩->同步->记录
## 无返回值
dowatching() {
    action=$1
    if [ "" = "$action" ]; then
        action=dolog
    fi

    $inotify_bin -qmre $inotify_type $inotify_path --format '"%w" "%f" "%e"'| while read DIR FILENAME EVENT TIME;
    do
        ##监听并操作
        ##########
        FILENAME=${FILENAME//\"/};
        DIR=${DIR//\"/};
        EVENT=${EVENT//\"/};
        #记录日志到当天的文件中
        if [ "$action" = "dolog" ]; then
            if [ "$iflog" = "true" ]; then
                echo $(date +%H:%M:%S) $EVENT $DIR$FILENAME >> ${log_path}dowatching_$(date "+%Y%m%d")
            fi
        fi
        
        #rsync同步 并记录日志
        if [ "$action" = "dorsync" ]; then
            dosyncfile $DIR$FILENAME
        fi
        
        #convert压缩图片并记录日志
        if [ "$action" = "doconvert" ]; then
        #按照日期进行分文件夹  现废弃
#            if [ ! -d $tmp_path$(date "+%Y%m%d") ]; then
#                docheckdir $tmp_path$(date "+%Y%m%d") true
#                if [ "$?" != "0" ]; then
#                    echo $(date "+%H:%M:%S") "cannotcreatedir" $tmp_path$(date "+%Y%m%d") >>${log_path}dowatching_createdir_$(date "+%Y%m%d")
#                    exit 1
#                fi
#            fi
#            doconvertpic $DIR$FILENAME $tmp_path$(date "+%Y%m%d")/$FILENAME
            doconvertpic $DIR$FILENAME $tmp_path$FILENAME
        fi
        
        #先压缩 再同步 再记录日志
        if [ "$action" = "order3" ]; then
            #根据扩展名改变策略定义接下来的操作文件名称
            if [ "$finished_ext" != "old" ]; then
                tmpsyncfilename=$tmp_path$(echo $FILENAME| cut -d '.' -f 1)$finished_ext
            else
                tmpsyncfilename=$tmp_path$FILENAME
            fi
            #压缩图片
            #按照日期进行分文件夹  现废弃
#            if [ ! -d $tmp_path$(date "+%Y%m%d") ]; then
#                docheckdir $tmp_path$(date "+%Y%m%d") true
#                if [ "$?" != "0" ]; then
#                    echo $(date "+%H:%M:%S") "cannotcreatedir" $tmp_path$(date "+%Y%m%d") >>${log_path}dowatching_createdir_$(date "+%Y%m%d")
#                    exit 1
#                fi
#            fi
#            doconvertpic $DIR$FILENAME $tmp_path$(date "+%Y%m%d")/$FILENAME
            doconvertpic $DIR$FILENAME $tmp_path$FILENAME

            if [ "$?" = "0" ]; then
                #记录日志
                dorecordtotext $tmpsyncfilename $text_path$(date "+%Y%m%d")$text_ext
            else
                continue
            fi

            #sleep 1  #不睡了  一条命令结束后 执行另一条
            #同步文件
            dosyncfile $tmpsyncfilename
        fi
    done

}

#************************************************************************#
##########################################################################
#*
#* inotify + rsync + convert + tar + log
#* 实时监控   同步文件  图片压缩   压缩   日志
#* 执行程序如下:
#*
##########################################################################
#************************************************************************#

action_type=$1;
if [ "$action_type" = "normal" ]; then #一般模式开启
    case "$2" in
        1) #只同步  
            if [ $# -lt 3 ]; then
                echo "
                只同步文件(需配置文件配合)
                Usage: $0 normal 1 filename
                "
                exit 1
            else
                dosyncfile $3
            fi
            ;;
        2) #只压缩
            if [ $# -lt 3 ]; then
                echo "
                只压缩图片(需要配置文件配合)
                Usage: $0 normal 2 filename targetfilename
                "
            else
                doconvertpic $3 $4
            fi
            ;;
        3) #只打包
            if [ $# -lt 3 ]; then
                echo "
                只打包文件或文件夹为tar.gz格式
                Usage: $0 normal 3 filepath targetname
                "
            else
                docompresstotargz $3 $4
            fi
            ;;
        4) #监听目录并记录日志
            if [ $# -lt 2 ]; then
                echo "
                监听目录并记录日志
                Usage: $0 normal 4
                "
            else
                dowatching dolog
            fi
            ;;
        5) #监听目录并压缩图片
            if [ $# -lt 2 ]; then
                echo "
                监听目录并压缩图片
                Usage: $0 normal 5
                "
            else
                dowatching doconvert
            fi
            ;;
        6) #监听目录并同步
            if [ $# -lt 2 ]; then
                echo "
                监听目录并同步
                Usage: $0 normal 6
                "
            else
                dowatching dorsync
            fi
            ;;
        7) #监听目录 压缩图片 同步 并记录日志
            if [ $# -lt 2 ]; then
                echo "
                监听目录 压缩图片 同步 并记录文件记录
                Usage: $0 normal 7
                "
            else
                dowatching order3
            fi
            ;;
        *)
            tput clear
            tput cup 3 15
            tput setaf 3
            echo "普通模式:"
            tput sgr0
            tput cup 5 15
            echo "1. 只同步"
            tput cup 6 15
            echo "2. 只压缩"
            tput cup 7 15
            echo "3. 只打包"
            tput cup 8 15
            echo "4. 监听目录并记录日志"
            tput cup 9 15
            echo "5. 监听目录并压缩图片"
            tput cup 10 15
            echo "6. 监听目录并同步"
            tput cup 11 15
            echo "7. 监听目录,压缩图片,同步压缩后的图片并记录步骤日志"
            tput bold
            tput cup 12 15
            echo "Usage: $0 normal {1|2|3|4|5|6|7}"
            tput sgr0
            tput rc
            ;;
    esac
elif [ "$action_type" = "daemon" ]; then #守护进程模式开启
    case "$2" in
        *)
            tput clear
            tput cup 3 15
            tput setaf 3
            echo "普通模式:"
            tput sgr0
            tput cup 5 15
            echo "4. 监听目录并记录日志"
            tput cup 6 15
            echo "5. 监听目录并压缩图片"
            tput cup 7 15
            echo "6. 监听目录并同步"
            tput cup 8 15
            echo "7. 监听目录,压缩图片,同步压缩后的图片并记录步骤日志"
            tput bold
            tput cup 9 15
            echo "Usage: $(dirname $0)/$twatchdog {4|5|6|7}"
            tput sgr0
            tput rc
            ;;
    esac
elif [ "$action_type" = "patch" ]; then #补丁的调用
    return 0
else
    tput clear
    tput cup 3 15
    tput setaf 3
    echo "模式选择."
    tput sgr0
    tput cup 5 17
    tput rev
    echo "普通模式:"
    tput sgr0
    tput cup 7 15
    echo "1. 只同步"
    tput cup 8 15
    echo "2. 只压缩"
    tput cup 9 15
    echo "3. 只打包"
    tput cup 10 15
    echo "4. 监听目录并记录日志"
    tput cup 11 15
    echo "5. 监听目录并压缩图片"
    tput cup 12 15
    echo "6. 监听目录并同步"
    tput cup 13 15
    echo "7. 监听目录,压缩图片,同步压缩后的图片并记录步骤日志"
    tput bold
    tput cup 14 15
    echo "Usage: $0 normal {1|2|3|4|5|6|7}"
    tput sgr0
    tput cup 16 17
    tput rev
    echo "守护进程模式:"
    tput sgr0
    tput cup 18 15
    echo "4. 监听目录并记录日志"
    tput cup 19 15
    echo "5. 监听目录并压缩图片"
    tput cup 20 15
    echo "6. 监听目录并同步"
    tput cup 21 15
    echo "7. 监听目录,压缩图片,同步压缩后的图片并记录步骤日志"
    tput bold
    tput cup 22 15
    echo "Usage: $(dirname $0)/$twatchdog {4|5|6|7}"
    tput sgr0
    tput rc
fi

#************************************************************************#
##########################################################################
#*
#* inotify + rsync + convert + tar + log
#* 实时监控   同步文件  图片压缩   压缩   日志
#* 一些写法的原因:
#*
##########################################################################
#************************************************************************#
#   1:log日志开关的判断  故意为之   考虑以后可能会修改根据不同的结果书写不同的东西 
#     并添加其他步骤所以分开验证
#   2:监听目录并判读那是否操作 采用黑白名单同时使用的方法  
#     可以保证文件扩展名没写全或漏掉部分 不影响程序使用
#   3:利用另一个twatchdog.sh脚本来做守护脚本 守护tools.sh脚本的4、5、6、7几个功
#     能
#   4:为了方便管理把压缩后的图片文件按照日期的天归档到一个文件夹下  这样每天管理
#   5:忽略文件ignorelist和dofilelist文件必须存在 而且最好里面写上相应的内容
#     因考虑到图片文件较大或网络延迟或程序脚本执行过快或并发等等因素导致文件未写全的时候
#     脚本已经开始执行，那么脚本判断该文件非图片文件 就需要配合这两个文件来处理了(谁能教教我shell写指针)
