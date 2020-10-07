#!/bin/bash

# LAFOREST Arthur
# 07/10/2020
# script d'install

yum update -y

setenforce 0
echo "SELINUX=permissive\nSELINUXTYPE=targeted" > /etc/selinux/config

yum install vim -y
yum install epel-release -y
yum install nginx -y
yum install tree -y
yum install python3 -y

# user web
useradd web -M -s /sbin/nologin
usermod -aG web wheels

# user backup
useradd backup -M -s /sbin/nologin

systemctl enable WebServer.service
systemctl start WebServer.service
