#!/bin/bash
##############################################
## 作用：自动将扫描的孙子 砌墙里
## 适用于：Centos6   
## 使用方法：在crontab -e里加上    
## 0 */1 * * * nohup ./iptables_ip.sh > /dev/null &  
## 脚本路径需要注意
## Json 2016-01-29
##############################################
logfile=/var/log/secure #系统日志文件地址 勿动
white_ips=./white_ips #白名单IP列表文件
iptables_rules=/etc/sysconfig/iptables #iptables默认路径
attc_max=1000 #限定攻击最大次数值 默认值1000
recordlog=./monior_ip_attc.log
curdate=$(date|awk '{print $2" "$3}') #按照日志格式获取当前天
today_attc_ips=$(cat $logfile|grep "$(echo $curdate)"|grep 'Failed password for'|awk -F'from' '{print $2}'|awk '{print $1}'|sort| uniq -c)
ifblack=0 #勿动
docounter=0 #计数器
#echo $today_attc_ips
#echo '=============='
## 验证ip是否已经加入过黑名单了，如果加入过返回1否则返回0。
checkAlreadyBlack() {
    blackip=$1
    checker=$(cat $iptables_rules|grep $blackip)
    if [ "" = "$checker" ]; then
        return 0
    else
        return 1
    fi
}


for ip in $today_attc_ips; do
    if [ "" = "$(echo $ip|grep '\.')" ]; then
        #攻击次数大于限定值 视为攻击ip
        if [ "$ip" -ge "$attc_max" ]; then
            ifblack=1
        fi
        #echo "攻击次数" $ip
    else
        if [ "$ifblack" = "1" ]; then
            #echo $ip
            checker=$(checkAlreadyBlack $ip)
            if [ "1" = "$?" ]; then
                continue
            fi
            #被脚本认定为攻击ip 验证白名单
            if [ "" != "$(cat $white_ips)" ]; then
                if [ "" = "$(cat $white_ips|grep $ip)" ]; then
                    echo "`iptables -I INPUT -s $ip -j DROP`"
                    docounter=$[$docounter+1]
                    echo $(date "+%Y%m%d %H:%M:%S") "这孙子攻击了,IP: " $ip >> $recordlog
                else
                    echo $(date "+%Y%m%d %H:%M:%S") "很奇怪的白名单IP: " $ip >> $recordlog
                fi
            else
                "`iptables -I INPUT -s $ip -j DROP`"
                docounter=$(`expr $docounter +1`)
                echo $(date "+%Y%m%d %H:%M:%S") "这孙子攻击了,IP_: " $ip >> $recordlog
            fi
            ifblack=0
        fi
    fi
done

#echo $docounter
#exit 1
if [ "0" -lt "$docounter" ]; then
    # echo "放心吧,我把攻击的孙子们砌墙里了!!!"
   /etc/init.d/iptables save
   service iptables restart
fi
