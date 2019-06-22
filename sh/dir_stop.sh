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

if [ "$4" == "" ]; then
        printf "fail#Unknow domain value"
        exit
fi
domain=$4

if [ "$5" == "" ]; then
        printf "fail#Unknow password value"
        exit
fi
password=$5

# Slave
if [ "$dtype" == "3" ]; then
	container="ldap"
        docker_compose="/home/ldap_slave/docker-compose.yml"

	pb_slapd=`/bin/pgrep slapd`
        docker-compose -f $docker_compose stop $container >/dev/null 2>&1
	pf_slapd=`/bin/pgrep slapd | wc -l`

	if [ "$pf_slapd" == 0 ]; then
		printf "ok"
	else
        	printf "false#Stop failed"
	fi
fi
