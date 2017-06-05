#!/bin/sh
#本地路径
SOURCEPATH=~/data/app/www/
#远端路径
REMOTEPATH=/data/wwwroot/
#ftp账号
FTPUSER=root
#ftp密码
FTPPASS=123456
#ftp地址
FTPSERVER=192.168.1.2
#ftp端口
FTPPORT=21
#忽略文件列表
IGNORELIST=~/data/app/www/.gitignore
#操作文件列表
ACTFILELIST=~/data/app/www/.actfilelist
#expect 命令位置
EXPECTCOMMAND=/usr/local/bin/expect
#ftp 命令位置
FTPCOMMAND=/usr/bin/ftp
SFTPCOMMAND=/usr/bin/sftp
#ftp or sftp
WHICHCOMMAND=sftp

doFtp() {
	if [ "$1" != "" ]; then
		filepath=$(dirname $1)
		if [ "$WHICHCOMMAND" = "ftp" ]; then
			$FTPCOMMAND -n  <<END_SCRIPT
open $FTPSERVER $FTPPORT
user $FTPUSER $FTPPASS
binary
hash
mkdir -p $filepath
cd $filepath
lcd $filepath
prompt
put $1
quit
END_SCRIPT
		elif [ "$WHICHCOMMAND" = "sftp" ]; then
			rfilepath=$REMOTEPATH/$filepath
			$EXPECTCOMMAND -c "
			spawn ${SFTPCOMMAND} ${FTPUSER}@${FTPSERVER}
			expect \"password: \"
			send \"${FTPPASS}\r\"
			expect \"sftp>\"
			send \"lcd ${SOURCEPATH}\r\"
			expect \"sftp>\"
			send \"mkdir -p ${rfilepath}\r\"
			expect \"sftp>\"
			send \"cd ${rfilepath}\r\"
			expect \"sftp>\"
			send \"put ${1}\r\"
			expect \"sftp>\"
			send \"bye\r\"
			expect \"#\"
			"
		fi
    fi
}

if [ ! -f $ACTFILELIST ]; then
	echo "$ACTFILELIST does not exists !!!"
	exit 1
fi

files=$(cat $ACTFILELIST)

if [ "" != "$files" ]; then
	filesarr[0]=''
	fileposit=0

	for i in ${files[*]}; do
		if [ "" != "$i" ] && [ -f $SOURCEPATH/$i ]; then
			filesarr[$fileposit]=$i
			#echo ${filesarr[$fileposit]}
			doFtp ${filesarr[$fileposit]} >> /dev/null &
			((fileposit+=1))
		fi
	done
else
	echo "$ACTFILELIST is empty !!!"
	exit 1
fi
