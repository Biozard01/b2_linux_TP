#!/bin/bash

# LAFOREST Arthur
# 13/10/2020
# script d'install

yum update -y

setenforce 0
sed -i 's/.*SELINUX=enforcing.*/SELINUX=permissive/' /etc/selinux/config

yum install vim -y
yum install tree -y
