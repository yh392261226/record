#!/bin/bash
###########################################################
# 将日志文件中的所有ip地址 根据访问次数限制值列出并显示出
# 该ip所属地等相关信息
#返回结果如下：
#"Times: " "2770" "ip": "66.249.64.237", "hostname": "crawl-66-249-64-237.googlebot.com", "city": "Mountain View", "region": "California", "country": "US", "loc": "37.4192,-122.0574", "org": "AS15169 Google Inc.", "postal": "94043"
###########################################################
if [ "" != "$1" ]; then
    logfile=$1                #获取用户输入的日志地址
else
	logfile=/data/access.log    #默认的日志地址
fi
minscore=1000                 #超过该值才列出 否则忽略

###先打出来一个临时的文件
cat $logfile | grep -v "127.0.0.1" | awk '{print $1}' | sort | uniq -c > /tmp/tmp_today_ips.log
###解析
for i in $(cat /tmp/tmp_today_ips.log | awk '{print $1}'); do
    if [ "$i" -gt "$minscore" ]; then
		countip=$(cat /tmp/tmp_today_ips.log | grep $i)
        curip=$(echo $countip | awk '{print $2}')
        echo "{ \"Times\":" "\""$(echo $countip|awk '{print $1}')"\"," $(curl -s http://ipinfo.io/$curip | sed -e "s,{\|},,g" ) "}"
    fi
done
rm -f /tmp/tmp_today_ips.log
echo "以上ip需要检测，查看日志!"
