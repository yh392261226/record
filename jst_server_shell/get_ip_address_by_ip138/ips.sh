#!/bin/bash
ips=./ips.txt
result_file=./result.txt
cleanips=$(cat $ips |grep '\.'|sort| uniq)
for ip in $cleanips; do
    cur_ip_addr=$(curl -s -d "ip=$ip" --header ":authority: tool.lu" --header ":path: /ip/ajax.html" --header ":scheme: https" --header "accept: application/json, text/javascript, */*; q=0.01" --header "cookie: slim_session=%7B%22slim.flash%22%3A%5B%5D%7D; uuid=f2cc834b-30fd-4c8b-ccdb-ad9dd9712478; Hm_lvt_0fba23df1ee7ec49af558fb29456f532=1596677905; Hm_lpvt_0fba23df1ee7ec49af558fb29456f532=1596677905; _access=7107ce25bfae2e94aa6e3d1a47d5a3a1464b660c667b5b81b77d6cc199de81d9"  https://tool.lu/ip/ajax.html | jq -r ".text.ip2region")
    if [ "" != "$cur_ip_addr" ]; then
        echo "$ip $cur_ip_addr" >> $result_file
    else
        echo "$ip Unknow address" >> $result_file
    fi
done
echo "Total( ip):"
cat $result_file | wc -l
