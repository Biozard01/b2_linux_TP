#!/bin/bash

# LAFOREST Arthur
# 13/10/2020
# script setup gitea

systemctl enable firewalld
systemctl start firewalld

firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload

wget -O gitea https://dl.gitea.io/gitea/1.12.5/gitea-1.12.5-linux-amd64
chmod +x gitea

useradd git -m -s /bin/bash

mkdir -p /var/lib/gitea/{custom,data,log}
usermod -a -G git git
chown -R git:git /var/lib/gitea/
chmod -R 750 /var/lib/gitea/
mkdir /etc/gitea
chown root:git /etc/gitea
chmod 770 /etc/gitea

export GITEA_WORK_DIR=/var/lib/gitea/

cp gitea /usr/local/bin/gitea

systemctl enable gitea.service

GITEA_WORK_DIR=/var/lib/gitea/ /usr/local/bin/gitea web -c /etc/gitea/app.ini