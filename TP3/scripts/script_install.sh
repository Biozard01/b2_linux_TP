#!/bin/bash

# LAFOREST Arthur
# 05/10/2020
# script d'install

yum update -y

setenforce 0
echo "SELINUX=permissive\nSELINUXTYPE=targeted" > /etc/selinux/config

yum install vim -y
yum install epel-release -y
yum install nginx -y
yum install tree -y
yum install python3 -y