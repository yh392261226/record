#!/bin/bash
s={"rv":0,flag:1,"url":"http://www.jinhill.com","msg":"test"}

parse_json(){
  echo $1 | sed 's/.*'$2':\([^,}]*\).*/\1/'
}

echo $s
rv=$(parse_json $s "rv")
url=$(parse_json $s "url")
flag=$(parse_json $s "flag")
msg=$(parse_json $s "msg")
echo $rv
echo $url
echo $flag
echo $msg
