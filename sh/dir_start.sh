#!/bin/bash

if [ $# -eq 0 ]; then
        printf "fail#Unknow value"
        exit
fi

if [ "$1" == "" ]; then
        printf "fail#Unknow hosts_id"
        exit
fi
hosts_id=$1

if [ "$2" == "" ]; then
        printf "fail#Unknow dtype value"
        exit
fi
dtype=$2

if [ "$3" == "" ]; then
        printf "fail#Unknow ipaddress value"
        exit
fi
ipaddress=$3

# SLAVE
if [ "$dtype" == "3" ]; then
	container="ldap"
        docker_compose="/home/ldap_slave/docker-compose.yml"

        docker-compose -f $docker_compose start $container >/dev/null 2>&1
	pf_slapd=`/bin/pgrep slapd | wc -l`

	if [ "$pf_slapd" == 1 ]; then
		printf "ok"
	else
        	printf "false#Start failed"
	fi
fi
