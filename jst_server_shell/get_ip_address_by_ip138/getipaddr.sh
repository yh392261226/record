#!/bin/bash
ips=./ips.txt
result_file=./result.txt
cleanips=$(cat $ips |grep '\.'|sort| uniq)
for ip in $cleanips; do
    cur_ip_addr=$(curl -s http://ip138.com/ips138.asp\?ip\=$ip\&action\=2 |iconv -f gb2312 -t UTF-8|grep '<td align="center"><ul class="ul1"><li>'|awk '{print $3}'|awk -F'：' '{print $2}')
    if [ "" != "$cur_ip_addr" ]; then
        echo "$ip $cur_ip_addr" >> $result_file
    else
        echo "$ip Unknow address" >> $result_file
    fi
done
echo "Total( ip):"
cat $result_file | wc -l
