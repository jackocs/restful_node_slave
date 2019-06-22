#!/bin/bash

ldap_config=$(/bin/docker volume inspect ldap_slave_ldapconfigvol --format '{{ .Mountpoint }}')
path_config="$ldap_config/slapd.d/"
slapcat -n2 -F $path_config |grep "uid:" |wc -l
