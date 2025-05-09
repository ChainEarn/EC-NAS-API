#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
#/usr/bin/mariadb -u root -p -e "show databases;"
MYSQL_PWD="" /usr/bin/mariadb -u root < $SCRIPT_DIR/create_dbtb.sql
MYSQL_PWD="" /usr/bin/mariadb -u root < $SCRIPT_DIR/create_user.sql
