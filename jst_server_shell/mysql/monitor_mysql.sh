#!/bin/bash
#############################################################
## monitor the mysql slave status
## get the master status
## me : Json
## 2016-01-27
#############################################################

MYSQL_USER=root
#MYSQL_PASS='3psHKP8Nzo.BX3q+'
MYSQL_PASS='admin123'
#MYSQL_HOST=127.0.0.1
MYSQL_HOST=localhost
MYSQL_PORT=3306

## 
## 检测mysql slave 状态
##
checkMysqlSlaveStatus() {
	# get where is mysql client command
	MYSQL_BIN=$(which mysql)
	# the SQL to get slave status
	COMMAND=$(mysql -u$MYSQL_USER -p$MYSQL_PASS -h$MYSQL_HOST -P$MYSQL_PORT -e'SHOW SLAVE STATUS\G')
	
	if [ "" = "$COMMAND" ] || [ "0" -ge "$(ps -ef|grep mysqld|grep -v grep|wc -l)" ]; then
	    echo "mysql server is down"
	    return 1;
	fi
	
	# get the status of slave io running & slave sql running
	IO_RUNNING=$(echo $COMMAND| grep 'Slave_IO_Running:'| awk '{print $2}')
	SQL_RUNNING=$(echo $COMMAND| grep 'Slave_SQL_Running:'| awk '{print $2}')
	LAST_IO_ERROR=$(echo $COMMAND| grep 'Last_IO_Error:'|awk '{print $0}'| awk -F'Last_IO_Error:' '{print $2}')

	if [ "IO_RUNNING" = "yes" ] && [ "SQL_RUNNING" = "yes" ]; then
		echo 'all ok';
	else
		# mysql slave is in trouble
		if [ "$IO_RUNNING" = "Connecting" ]; then
			# if mysql is in connecting wait 5 seconds retry again
			sleep 5
			checkMysqlSlaveStatus	
		fi
        # if mysql slave is in trouble recorde the error then ignore the error
        echo $(date "+%Y-%m-%d %H:%M:%S") $LAST_IO_ERROR >> ./slave_log.log
        mysql -u$MYSQL_USER -p$MYSQL_PASS -h$MYSQL_HOST -P$MYSQL_PORT -e'stop slave; set GLOBAL SQL_SLAVE_SKIP_COUNTER=1; start slave;';
		echo 'trouble';
		return 1;
	fi
}

##
## 检测mysql master 状态
##
checkMysqlMasterStatus() {
	# get where is mysql client command
	MYSQL_BIN=$(which mysql)
	# the SQL to get slave status
	COMMAND=$(mysql -u$MYSQL_USER -p$MYSQL_PASS -h$MYSQL_HOST -P$MYSQL_PORT -e'SHOW MASTER STATUS;')
	
	if [ "" = "$COMMAND" ]; then
	    echo "mysql server is down"
	    return 1;
	fi
	
	echo $COMMAND
	return 0
}





case "$1" in
    slave)
        checkMysqlSlaveStatus
    ;;
    master)
        checkMysqlMasterStatus
    ;;
    *)
    echo "Usage: $0 slave| master"
    echo "功能： $0 从机| 主机"
    exit 1
    ;;
esac
