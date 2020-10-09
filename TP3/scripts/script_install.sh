#!/bin/bash

# LAFOREST Arthur
# 07/10/2020
# script d'install

yum update -y

setenforce 0
sed -i 's/.*SELINUX=enforcing.*/SELINUX=permissive/' /etc/selinux/config

yum install vim -y
yum install epel-release -y
yum install nginx -y
yum install tree -y
yum install python3 -y

# user web
useradd web -M -s /sbin/nologin
echo 'web   ALL=(ALL)   NOPASSWD: ALL' >> /etc/sudoers

# user backup
useradd backup -M -s /sbin/nologin

mv /tmp/WebServer.service /etc/systemd/system/WebServer.service
mv /tmp/backup.service /etc/systemd/system/backup.service

mkdir /home/backup/backupDir

systemctl enable WebServer.service
systemctl start WebServer.service
