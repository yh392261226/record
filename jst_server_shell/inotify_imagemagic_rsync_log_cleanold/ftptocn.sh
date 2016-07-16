#!/bin/bash
d=`date "+%Y%m%d" -d yesterday`;

f1=$d"_web1_ai.tar.gz";
f2=$d"_web1_original.tar.gz";
ftpip=127.0.0.1
ftpport=21
ftpuser=test
ftppass=test22222
BACK_DIR="/data/everyday_ai/";
BACK_DIR1="/data/everyday_tar/";

ftp -n<<!

open $ftpip $ftpport 
user $ftpuser $ftppass
binary
hash
lcd ${BACK_DIR}
cd /enphoto
prompt
mput $f1
lcd ${BACK_DIR1}
mput $f2
close
bye
!
