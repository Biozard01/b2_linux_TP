#!/bin/bash

# LAFOREST Arthur
# 24/10/2020
# script d'install node3

yum install epel-release -y
yum install nginx -y

systemctl enable nginx
systemctl start nginx