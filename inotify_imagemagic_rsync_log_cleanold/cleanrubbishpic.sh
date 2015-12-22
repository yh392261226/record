#!/bin/bash

##获取要操作的所有文件列表
getoperatefileslist() {
    result=$(ls $actionpath | grep $operatedate|sed "s,${actionpath},,g");
    echo $result| sed 's, ,\n,g' > /tmp/$operatedate
}

##比对得到要处理的文件列表
getrubbishbydiff() {
    if [ ! -f $usingfile ]; then
        rm -f /tmp/$operatedate
        touch $alreadypath/$curlock$curlockext
        return 0
    fi
    cat $usingfile| sed "s,${usingexclude},,g" > /tmp/2_$operatedate
    result=$(/usr/bin/diff -w /tmp/$operatedate /tmp/2_$operatedate);
    if [ "" = "$result" ]; then
        rm -f /tmp/$operatedate /tmp/2_$operatedate
        touch $alreadypath/$curlock$curlockext
        return 0
    fi
    #result=$(/usr/bin/diff -w /tmp/$operatedate $(cat $usingfile| sed "s,${usingexclude},,g")| grep "< "|sed 's,< ,,g');
    echo $result| grep "< "|sed 's,< ,,g' > $alreadypath/$curlock
}

##处理文件移动到备份区
movetobackup() {
    for dofile in $(cat $alreadypath/$curlock); do
        if [ -f $actionpath/$dofile ]; then
            mv $actionpath/$dofile $backuppath/$dofile
        fi
    done;
}

##将处理完的文件锁加上后缀名 表示完成
addexttolock() {
    mv $alreadypath/$curlock $alreadypath/$curlock$curlockext
}

##获取未操作过的
getdidnot() {
    if [ "" = "$(ls $usingpath)" ]; then
        echo "没有比对文件"
        return 1
    else
        needle=$(ls $usingpath| sed "s,${usingext},,g");
    fi
    if [ "" = "$(ls $alreadypath)" ]; then
        echo "没有操作过的记录"
        return 1
    else
        passed=$(ls $alreadypath| sed "s,${curlockext},,g");
    fi
    echo $needle|sed 's, ,\n,g' > /tmp/didnot_needle
    echo $passed|sed 's, ,\n,g' > /tmp/didnot_passed
    diffrent=$(/usr/bin/diff -w /tmp/didnot_needle  /tmp/didnot_passed)
    result=""
    if [ "" != "$diffrent" ]; then
        result=$(/usr/bin/diff -w /tmp/didnot_needle /tmp/didnot_passed | grep '< '| sed 's,< ,,g')
    fi
    echo $result
#    rm -f /tmp/didnot_needle /tmp/didnot_passed
}

##某天已处理过的
getalreadybyday() {
    if [ ! -f $alreadypath/$curlock$curlockext ];then
        return 1;
    fi
    content=$(cat $alreadypath/$curlock$curlockext);
    if [ "" != "$content" ];then
        echo $content|sed 's, ,\n,g'|sed -n "/${operatedate}/p";
    fi
}



##
## 清理指定目录中的垃圾文件
## 需要指定已使用中的图片列表
## 只能清理指定日期

####配置文件内容begin
#当前日期的前一天的时间 为处理日期 为避免误伤当前正在使用的 时间上必须获取服务器时间前一天的
operatedate=$(date "+%Y%m%d" -d yesterday);
#操作目录
actionpath=/root/json_packages/diff/sourcepath
#备份目录
backuppath=/root/json_packages/diff/backuppath
#使用中的文件列表文件所在目录   里面的文件以20151211.txt 这样的形式存在
usingpath=/root/json_packages/diff/usingfile
#文件后缀名
usingext=.txt
#当天要处理的前一天的比对文件  不需要手动写
usingfile=$usingpath/$operatedate$usingext
#比对文件中需要忽略前缀  只留下文件名
usingexclude=/root/json_packages/diff/sourcepath/
#已完成记录 相当于log日志目录
alreadypath=/root/json_packages/diff/already
#指定处理日期的文件锁名称 文件中包含处理的文件名 当做日志来用
curlock=$operatedate
#处理完成后再加上后缀表示已处理完
curlockext=.lock
####配置文件内容end


case "$1" in
    day)
        getoperatefileslist;
        sleep 3;
        getrubbishbydiff
        sleep 1;
        movetobackup
        sleep 3;
        addexttolock
        rm -f /tmp/$operatedate /tmp/2_$operatedate
        echo "done";
        ;;
    days)
        for dodate in $(ls $usingpath|cut -d '.' -f 1); do
            curdate=$(date "+%Y%m%d");  #建议放在这里 每次执行的时候都重新赋值一次当前日期  避免后半夜执行 跨过12点
            if [ "$dodate" = "$curdate" ]; then
                continue;
            fi
            operatedate=$dodate;
            usingfile=$usingpath/$operatedate$usingext
            curlock=tmp_lock_$operatedate
            getoperatefileslist;
            sleep 3;
            getrubbishbydiff;
            sleep 1;
            movetobackup;
            sleep 3;
            addexttolock;
            rm -f /tmp/$operatedate
        done
        echo "done";
        ;;
    mark) ##处理指定文件中的文件列表
        if [ "" = "$2" ]; then
            echo "请指定比对文件"
            exit 1
        fi
        dofilesname=$2;
        for dofile in $(cat $dofilesname|sed "s,${usingexclude},,g"); do
            if [ -f $actionpath/$dofile ]; then
                mv $actionpath/$dofile $backuppath/$dofile
            fi
        done;
        echo "done";
        ;;
    didnot)
        getdidnot;
        ;;
    checkday)
        if [ "" = "$2" ]; then
            echo "请指定日期"
            exit 1
        fi
        operatedate=$2;
        getalreadybyday
        ;;
       *)
        echo "
        ***必须依托于usingfile目录中的列表文件***
        Usage 使用方法 $0  
        day 前一天的 
        days 今天之前的全部日期 
        mark 指定要删除的文件内容(第二个参数是比对文件名 :./todo.txt) 
        didnot 查看比对文件中没有操作的 
        checkday 查看某一天的操作记录(第二个参数是日期:20151212)
        ";
        exit 1;
        ;;
esac

