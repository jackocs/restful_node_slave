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
ipslave=$3

if [ "$4" == "" ]; then
        printf "fail#Unknow ip master value"
        exit
fi
ipmaster=$4

if [ "$5" == "" ]; then
        printf "fail#Unknow domain value"
        exit
fi
domain=$5

if [ "$6" == "" ]; then
        printf "fail#Unknow password value"
        exit
fi
adminpass=$6

if [ "$7" == "" ]; then
        printf "fail#Unknow desc value"
        exit
fi
desc=$7

# LDAP Slave
if [ "$dtype" == "3" ]; then
	container="ldap"
        docker_compose="/home/ldap_slave/docker-compose.yml"

	pb_slapd=`/bin/pgrep slapd`
        docker-compose -f $docker_compose down -v >/dev/null 2>&1
	sleep 1
	ckSlpad=$(/bin/curl --silent http://$ipslave:3000/api/v1/dir/install/$domain/$adminpass/$ipslave/$desc/3/$ipmaster/admin)
        #echo $ckSlpad

	pf_slapd=`/bin/pgrep slapd`

	if [ "$pb_slapd" != "$pf_slapd" ]; then
		printf "ok"
	else
        	printf "false#Re-Sync failed"
	fi
fi
