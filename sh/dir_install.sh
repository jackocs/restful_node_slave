#!/bin/bash
if [ $# -eq 0 ]; then
        printf "fail#Unknow value"
        exit
fi

if [ "$1" == "" ]; then
        printf "fail#Unknow domain"
        exit
else
        domain=$1
fi

if [ "$2" == "" ]; then
        printf "fail#Unknow password"
        exit
else
        pass=$2
fi

if [ "$3" == "" ]; then
        printf "fail#Unknow ip"
        exit
else
        ipaddress=$3
fi

if [ "$4" == "" ]; then
        printf "fail#Unknow desc"
        exit
else
        desc=$4
fi

if [ "$5" == "" ]; then
        printf "fail#Unknow dtype_id"
        exit
else
        dtype_id=$5
fi

if [ "$6" == "" ]; then
        printf "fail#Unknow ipmaster"
        exit
else
        ipmaster=$6
fi

if [ "$7" == "" ]; then
        printf "fail#Unknow owner"
        exit
else
        owner=$7
fi

if [ "$8" == "" ]; then
        printf "fail#Unknow basedn"
        exit
else
        basedn=$8
fi

check=`/bin/curl http://$ipaddress:3000/api/v1/node`
if [ "$check" != "OK" ]; then
        printf "fail#Can not start node $ipaddress"
        exit
fi

#primary master
if [ "$dtype_id" == "1" ]; then
	ckSlpad=`/bin/curl http://$ipaddress:3000/api/v1/ckSlpad`
	if [ "$ckSlpad" == "already" ]; then
        	printf "fail#Already installed $ipaddress"
        	exit
	fi
	
	container="ldap"
	docker_compose="/home/ldap_slave/docker-compose.yml"

	docker-compose -f $docker_compose up -d >/dev/null 2>&1

	/home/ldap_slave/setupLDAP.sh $domain $pass $ipmaster

	docker-compose -f $docker_compose restart $container >/dev/null 2>&1

	/home/ldap_slave/config-ldap.sh $domain $pass

	docker-compose -f $docker_compose restart $container >/dev/null 2>&1

	install=`docker inspect -f '{{.State.Status}}' $container`

        #mount data

        date_new=$(date '+%Y%m%d%H%M')
        ldap_data=`docker volume inspect ldap_ldapdatavol --format '{{ .Mountpoint }}'`
        if [ -d "/var/lib/ldap" ]; then
            /bin/mv /var/lib/ldap /tmp/ldap_$date_new
        fi
        /bin/cd /var/lib/
        /bin/ln -s $ldap_data ldap
fi

# LDAP SLAVE
if [ "$dtype_id" == "3" ]; then
	printf "OK#$domain $pass $ipaddress $desc $dtype_id $owner"
#	master=`/bin/perl /home/restful_node/db/dir_queryMaster.pl`
#	if [ "$master" != "null" ]; then
#		install=`/home/restful_node/sh2/runConfigLDAP_remote_CentOS7.bash $domain $pass $ipaddress $master`
#		#enable sync master1
#		if [ "$install" == "ok#" ] || [ "$install" == "ok" ]; then
#			/home/restful_node/sh2/Replication_reinstall_master.sh $domain $pass $master $ipaddress 1
#			/home/restful_node/sh2/config_rsyslogServer_add.sh $master $ipaddress
#		fi
#	fi
fi
