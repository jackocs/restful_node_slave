#!/bin/bash
#ckSlpad=`/bin/ps -ef |grep slapd |grep -v grep |wc -l`
ckSlpad=`docker ps -a --format "{{.ID}}" --filter "name=ldap" |wc -l`
if [ $ckSlpad == "1" ]; then
        echo "already"
        exit
else
	echo "service stop or application not install"
fi
