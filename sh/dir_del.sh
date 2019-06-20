#!/bin/bash

if [ $# -eq 0 ]; then
        printf "fail#Unknow value"
        exit
fi

if [ "$1" == "" ]; then
        printf "fail#Unknow dtype value"
        exit
fi
dtype=$1

if [ "$2" == "" ]; then
        printf "fail#Unknow ipaddress value"
        exit
fi
ipaddress=$2

if [ "$3" == "" ]; then
        printf "fail#Unknow domain value"
        exit
fi
domain=$3

if [ "$4" == "" ]; then
        printf "fail#Unknow password value"
        exit
fi
password=$4

# LDAP SLAVE
if [ "$dtype" == "3" ]; then
	dockerfile="/home/ldap_slave/docker-compose.yml"
	if [ -f "$dockerfile" ] ; then
		docker-compose -f $dockerfile down -v
	fi

	# Cehck process
	CONTAINER_NAME="ldap"
	COUNT=$(docker ps -a | grep "$CONTAINER_NAME" | wc -l)
	if [ $COUNT == 0 ]; then
		echo "ok"
	fi
fi
