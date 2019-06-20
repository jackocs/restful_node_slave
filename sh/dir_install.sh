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

check=`/bin/curl --silent http://$ipaddress:3000/api/v1/node`
if [ "$check" != "OK" ]; then
        printf "fail#Can not start node $ipaddress"
        exit
fi

# LDAP Slave
if [ "$dtype_id" == "3" ]; then
	#printf "OKK#$domain $pass $ipaddress $desc $dtype_id $owner"
	ckSlpad=`/bin/curl --silent http://$ipaddress:3000/api/v1/ckSlpad`
	if [ "$ckSlpad" == "already" ]; then
        	printf "fail#Already installed $ipaddress"
        	exit
	fi
	
	container="ldap"
	docker_compose="/home/ldap_slave/docker-compose.yml"

	# Create Docker Compose file
	echo "version: '3'" > $docker_compose
	echo "" >> $docker_compose
	echo "services:" >> $docker_compose
	echo "  ldap:" >> $docker_compose
	echo "    image: ijapan/identityldap:1.0" >> $docker_compose
	echo "    container_name: ldap" >> $docker_compose
	echo "    environment:" >> $docker_compose
	echo "      - 'TZ=Asia/Bangkok'" >> $docker_compose
	echo "    volumes:" >> $docker_compose
	echo "      - ldapdatavol:/var/lib/ldap" >> $docker_compose
	echo "      - ldapconfigvol:/etc/openldap" >> $docker_compose
	echo "      - /home/ldap_slave/init/:/home/init" >> $docker_compose
	echo "    networks:" >> $docker_compose
	echo "      - overlay" >> $docker_compose
	echo "    ports:" >> $docker_compose
	echo "      - '389:389'" >> $docker_compose
	echo "      - '636:636'" >> $docker_compose
	echo "    logging:" >> $docker_compose
	echo "      driver: syslog" >> $docker_compose
	echo "      options:" >> $docker_compose
	echo "        syslog-address: 'tcp://$ipmaster:5514'" >> $docker_compose
	echo "        syslog-format: 'rfc5424micro'" >> $docker_compose
	echo "        syslog-facility: 'local4'" >> $docker_compose
	echo "    restart: always" >> $docker_compose
	echo "" >> $docker_compose
	echo "networks:" >> $docker_compose
	echo "  overlay:" >> $docker_compose
	echo "" >> $docker_compose
	echo "volumes:" >> $docker_compose
	echo "  ldapdatavol:" >> $docker_compose
	echo "      external: false" >> $docker_compose
	echo "  ldapconfigvol:" >> $docker_compose
	echo "      external: false" >> $docker_compose

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
        /bin/ln -s $ldap_data /var/lib/ldap
fi

#update DB
sleep 2
if [ "$install" == "running" ]; then
        status=1
#        /bin/perl /home/restful_node/db/dir_install.pl $ipaddress $desc $dtype_id $owner $status $basedn

        # create crontab monitor
#        croncmd="/bin/perl /home/restful_node/sh2/monitor_ldap/ldap_response_time.pl -h 127.0.0.1 -p 389 -D 'cn=Manager,$basedn' 2>&1"
#        cronjob="*/30 * * * * $croncmd"
#        ( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

        # config logs server
#        sh  /home/restful_node/sh/config_rsyslogServer.sh

        # /bin/perl /home/restful_node/sh2/monitor_ldap/ldap_response_time.pl -h 127.0.0.1 -p 389 -D "cn=Manager,dc=jitech,dc=co,dc=th"
        printf "ok"
fi
