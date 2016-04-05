#!/bin/bash
for ip in $(cat ./blacklist); do
	ptables -I INPUT -s $ip -jDROP   
done

/etc/init.d/iptables save
service iptables restart


