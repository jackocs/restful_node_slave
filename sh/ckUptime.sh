#!/bin/bash

ckUptime=`docker ps -a --filter Name=ldap --format "{{.Names}}: {{.Status}}" |cut -f2 -d":" | xargs echo -n`
if [ -z "$ckUptime" ]
then
	echo "service stop or application not install"
else
	echo -e "$ckUptime\c"
fi
