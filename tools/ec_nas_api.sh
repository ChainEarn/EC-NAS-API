#!/bin/bash

if [ $# != 1 ]; then
        echo -e "USAGE:\n\tec_nas_api.sh start\n\tec_nas_api.sh stop\n\tec_nas_api.sh restart\n"
        exit 1
fi

if [ "$1" = "start" ]; then
	systemctl start csdod
	systemctl start mariadb
	systemctl start openresty
	exit 0
fi
if [ "$1" = "stop" ]; then
	systemctl stop csdod
	systemctl stop mariadb
	systemctl stop openresty
	exit 0
fi
if [ "$1" = "restart" ]; then
	systemctl restart csdod
	systemctl restart mariadb
	systemctl restart openresty
	exit 0
fi
