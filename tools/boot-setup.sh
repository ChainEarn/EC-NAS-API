#!/bin/bash

# 获取操作系统ID
OS_ID=$(grep -oP '^ID=\K.*' /etc/os-release)

systemctl start sshd
systemctl start csdod
systemctl start mariadb
systemctl start openresty
