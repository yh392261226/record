#!/bin/bash
#************************************************************************#
##########################################################################
#*
#* inotify + sftp
#* 实时监控   sftp
#* 实时监听sftp目录， 如果发生改变自动同步到服务器。
#* 配置参数如下:
#*
##########################################################################
#************************************************************************#
#
username=$1
#监控的目录 单目录监控 多目录过于耗费资源
inotify_path=/wwwroot
#日志目录
log_path=/jst_server_shell/web_watch/log
#实时监听命令位置
inotify_bin=/usr/local/bin/inotifywait
lftp_bin=/usr/local/lftp
sftp_bin=/usr/local/sftp
#create新增 modify修改 delete删除 多个用,分割
inotify_type=create,modify,delete
#log记录开关 true开启
iflog=true
#用户列表
userlist=("image" "phoebe" "soufeel_sftp" "soufeel_v1")
usercount=${#userlist[@]}
#密码列表
passlist=("image_pass" "phoebe_pass" "soufeel_sftp_pass" "soufeel_v1_pass")
#用户对应本地服务器路径列表
pathlist=("/data/image" "/data/phoebe" "/data/sftp" "/data/v1")
pathcount=${#pathlist[@]}
#远端服务器ip
remotehostlist=("192.168.3.222" "192.168.3.223" "192.168.3.224" "192.168.3.221")
#用户对应远端服务器路径列表
remotepathlist=("/remote/data/image" "/remote/data/phoebe" "/remote/data/sftp" "/remote/data/v1")
#验证开关(下面代码用的)
checkusername=0
checkpathname=0

###根据用户名获取用户相关信息
###用法：getuserinfobyname [username]
getuserinfobyname() {
    if [ "" != "$1" ]; then
        username=$1
    fi
    usermark=-1
    i=0
    while [ "$i" -le "$usercount" ]; do
        if [ "" != "${userlist[$i]}" ]; then
            if [ "${userlist[$i]}" = "$username" ]; then
                checkusername=1
                usermark=$i
                break 3;
            fi
        fi
        i=$((${i}+1))
    done
    if [ "0" = "$checkusername" ]; then
        return 0
        #Username does not exists.
    fi
    user_path=${pathlist[$usermark]} #当前用户的目录
    user_remote_path=${remotepathlist[$usermark]} #当前用户的远端目录
    user_remote_host=${remotehostlist[$usermark]} #当前用户的远端ip
    userpass=${passlist[$usermark]} #当前用户的密码
}

###根据用户本地目录获取用户用户相关信息
###用法：getuserinfobypath user_path
getuserinfobypath() {
    user_path=$1
    usermark=-1
    if [ "" = "$user_path" ];then
        return 0
    fi
    j=0
    while [ "$j" -le "$pathcount" ]; do
        if [ "" != "${pathlist[$j]}" ]; then
            if [ "${pathlist[$j]}" = "$user_path" ]; then
                checkpathname=1
                usermark=$j
                break 3;
            fi
        fi
        j=$((${j}+1))
    done
    if [ "0" = "$checkpathname" ]; then
        return 0
        #Userpath does not exists.
    fi
    user_path=${pathlist[$usermark]} #当前用户的目录
    user_remote_path=${remotepathlist[$usermark]} #当前用户的远端目录
    user_remote_host=${remotehostlist[$usermark]} #当前用户的远端ip
    userpass=${passlist[$usermark]} #当前用户的密码
    username=${userlist[$usermark]} #当前用户
}


#########################
##测试用
# echo $username
# echo $userpass
# echo $user_path
# echo $user_remote_path
# echo $user_remote_host
# exit 1
#########################


###sftp操作
##上传
uploader() {
    $filename=$1
    echo $filename
    exit 1;
    # $lftp_bin -u $username,$userpass $sftp_bin://$user_remote_host << EOF
    # cd $user_remote_host
    # put $filename $user_remote_path/$filename
    # bye
    # EOF
}
#
# ##下载
# downloader() {
#     $filename=$1
#     $lftp_bin -u $username,$userpass $sftp_bin://$user_remote_host << EOF
#     cd $user_remote_host
#     get $user_remote_path/$filename $filename
#     bye
#     EOF
# }



###监听并操作
dowatching() {
    $inotify_bin -qmre $inotify_type $inotify_path --format '"%w" "%f" "%e"'| while read DIR FILENAME EVENT TIME;
    do
        ##监听并操作
        ##########
        FILENAME=${FILENAME//\"/};
        DIR=${DIR//\"/};
        EVENT=${EVENT//\"/};
        EXT=${FILENAME##*.};
        tmpusername=$(sed "s,$inotify_path,," $DIR | cut -d '/' -f 2)
        if [ "" != "$tmpusername" ]; then
            getuserinfobyname $tmpusername  #根据用户名获取这个用户的信息
        fi
        if [ "" = "$userpass" ]; then   #没有的话 再用这个目录找一次
            getuserinfobypath $DIR
            if [ "" = "$userpass" ]; then
                return 0  #没有这个账户吧  或者设置错误 反正根据这个目录没找到这个用户
            fi
        fi
        #用户的相关信息已经有了  现在执行ftp操作
        uploader $(sed "s,$inotify_path,," $DIR)/$filename
    done
}
##启动执行监听
dowatching
