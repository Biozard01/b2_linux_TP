# TP 3

## I. Services systemd

1. Intro

- Utilisez la ligne de commande pour sortir les infos suivantes :

- afficher le nombre de services systemd dispos sur la machine

```bash
[vagrant@tp3 ~]$ systemctl list-unit-files --type=service | tail -1 | cut -d " " -f 1
155
[vagrant@tp3 ~]$
```

- afficher le nombre de services systemd actifs et en cours d'exécution ("running") sur la machine

```bash
[vagrant@tp3 ~]$ systemctl -t service --all | grep running | wc -l
17
[vagrant@tp3 ~]$
```

- afficher le nombre de services systemd qui ont échoué ("failed") ou qui sont inactifs ("exited") sur la machine

```bash
[vagrant@tp3 ~]$ systemctl -t service --all | grep -E 'inactive|failed' | wc -l
75
[vagrant@tp3 ~]$
```

- afficher la liste des services systemd qui démarrent automatiquement au boot ("enabled")

```bash
[vagrant@tp3 ~]$ systemctl list-unit-files --type=service | grep enabled | wc -l
32
[vagrant@tp3 ~]$
```

## 2. Analyse d'un service

- Etudiez le service nginx.service

  - déterminer le path de l'unité nginx.service

    ```bash
    [vagrant@tp3 ~]$ systemctl cat nginx.service
    # /usr/lib/systemd/system/nginx.service
    ```

  - afficher son contenu et expliquer les lignes qui comportent :

    ```bash
    ExecStart=/usr/sbin/nginx
    ```

    Des commandes avec leurs arguments sont executer quand se service se lance. Pour chaque commandes le premire argument doit être un path absolu vers un executable ou un ficher sans slash.

    ```bash
    ExecStartPre=/usr/bin/rm -f /run/nginx.pid
    ExecStartPre=/usr/sbin/nginx -t
    ```

    Ce sont les commandes additionel qui sont executer avant ou après ExecStart=

    ```bash
    PIDFile=/run/nginx.pid
    ```

    C'est le chemin vers le PID du service.

    ```bash
    Type=forking
    ```

    Configure le type du process au démarrage pour ce service.

    ```bash
    ExecReload=/bin/kill -s HUP $MAINPID
    ```

    Commandes à executer pour enclencher un reload de la config du service

    ```bash
    Description=The nginx HTTP and reverse proxy server
    ```

    Description du service

    ```bash
    After=network.target remote-fs.target nss-lookup.target
    ```

    Ce sont les dépendence du service

- Listez tous les services qui contiennent la ligne WantedBy=multi-user.target

```bash
[vagrant@tp3 ~]$ grep -r "WantedBy=multi-user.target" /run/systemd/transient/* /etc/systemd/system/* /run/systemd/generator/* /usr/lib/systemd/system/*
grep: /run/systemd/transient/*: No such file or directory
/etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service:WantedBy=multi-user.targe
/usr/lib/systemd/system/auditd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/brandbot.path:WantedBy=multi-user.target
/usr/lib/systemd/system/chronyd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/chrony-wait.service:WantedBy=multi-user.target
/usr/lib/systemd/system/cpupower.service:WantedBy=multi-user.target
/usr/lib/systemd/system/crond.service:WantedBy=multi-user.target
/usr/lib/systemd/system/ebtables.service:WantedBy=multi-user.target
/usr/lib/systemd/system/firewalld.service:WantedBy=multi-user.target
/usr/lib/systemd/system/fstrim.timer:WantedBy=multi-user.target
/usr/lib/systemd/system/gssproxy.service:WantedBy=multi-user.target
/usr/lib/systemd/system/irqbalance.service:WantedBy=multi-user.target
/usr/lib/systemd/system/machines.target:WantedBy=multi-user.target
/usr/lib/systemd/system/NetworkManager.service:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs-client.target:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs-rquotad.service:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs-server.service:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs.service:WantedBy=multi-user.target
/usr/lib/systemd/system/nginx.service:WantedBy=multi-user.target
/usr/lib/systemd/system/postfix.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rdisc.service:WantedBy=multi-user.target
/usr/lib/systemd/system/remote-cryptsetup.target:WantedBy=multi-user.target
/usr/lib/systemd/system/remote-fs.target:WantedBy=multi-user.target
/usr/lib/systemd/system/rhel-configure.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rpcbind.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rpc-rquotad.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rsyncd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rsyslog.service:WantedBy=multi-user.target
/usr/lib/systemd/system/sshd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/tcsd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/tuned.service:WantedBy=multi-user.target
/usr/lib/systemd/system/vmtoolsd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/wpa_supplicant.service:WantedBy=multi-user.target
[vagrant@tp3 ~]$
```

## 3. Création d'un service

### A. Serveur web

- Créez une unité de service qui lance un serveur web

  [WebServer.service](./systemd/units/WebServer.service)

- Lancer le service

```bash
[vagrant@tp3 system]$ sudo systemctl status WebServer.service
● WebServer.service - server web pour le tp3
   Loaded: loaded (/etc/systemd/system/WebServer.service; disabled; vendor preset: disabled)
   Active: active (running) since Wed 2020-10-07 14:16:03 UTC; 4min 21s ago
 Main PID: 4208 (sudo)
   CGroup: /system.slice/WebServer.service
           ‣ 4208 /usr/bin/sudo /usr/bin/python3 -m http.server 1025

Oct 07 14:16:02 tp3.b2 systemd[1]: Starting server web pour le tp3...
Oct 07 14:16:02 tp3.b2 sudo[4201]:      web : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/bin/firewall-cmd --add...25/tcp
Oct 07 14:16:03 tp3.b2 systemd[1]: Started server web pour le tp3.
Oct 07 14:16:03 tp3.b2 sudo[4208]:      web : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/bin/python3 -m http.server 1025
Hint: Some lines were ellipsized, use -l to show in full.
[vagrant@tp3 system]$
```

- faites en sorte que le service s'allume au démarrage de la machine

```bash
[vagrant@tp3 system]$ sudo systemctl enable WebServer.service
Created symlink from /etc/systemd/system/multi-user.target.wants/WebServer.service to /etc/systemd/system/WebServer.service.
[vagrant@tp3 system]$
```

- prouver que le serveur web est bien fonctionnel

```bash
[vagrant@tp3 system]$ curl localhost:1025
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Directory listing for /</title>
</head>
<body>
<h1>Directory listing for /</h1>
<hr>
<ul>
<li><a href="bin/">bin@</a></li>
<li><a href="boot/">boot/</a></li>
<li><a href="dev/">dev/</a></li>
<li><a href="etc/">etc/</a></li>
<li><a href="home/">home/</a></li>
<li><a href="lib/">lib@</a></li>
<li><a href="lib64/">lib64@</a></li>
<li><a href="media/">media/</a></li>
<li><a href="mnt/">mnt/</a></li>
<li><a href="opt/">opt/</a></li>
<li><a href="proc/">proc/</a></li>
<li><a href="root/">root/</a></li>
<li><a href="run/">run/</a></li>
<li><a href="sbin/">sbin@</a></li>
<li><a href="srv/">srv/</a></li>
<li><a href="swapfile">swapfile</a></li>
<li><a href="sys/">sys/</a></li>
<li><a href="tmp/">tmp/</a></li>
<li><a href="usr/">usr/</a></li>
<li><a href="var/">var/</a></li>
</ul>
<hr>
</body>
</html>
[vagrant@tp3 system]$
```

### B. Sauvegarde

- Créez une unité de service qui déclenche une sauvegarde avec votre script

## II. Autres fonctionnalités

### 1. Gestion de boot

```bash
[vagrant@tp3]$ bash systemd-analyze plot > plot.svg
```

Après analyse du fichier plot.svg, les 3 services les plus lents à démarrer sont :

```bash
web.service
firewalld.service
swapfile.swap
```

### 2. Gestion de l'heure

```bash
[vagrant@tp3 ~]$ timedatectl
      Local time: Fri 2020-10-09 14:23:20 UTC
  Universal time: Fri 2020-10-09 14:23:20 UTC
        RTC time: Fri 2020-10-09 14:23:18
       Time zone: UTC (UTC, +0000)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a
```

On est synchro sur un serveur NTP.

Le fuseau horraire est : Time zone: UTC (UTC, +0000).

On liste tout les fuseaux horaire disponible :

```bash
[vagrant@tp3]$ timedatectl list-timezones
Africa/Abidjan
Africa/Accra
Africa/Addis_Ababa
[...]
```

On passe en fuseaux horaire America/Chicago

```bash
[vagrant@tp3]$ timedatectl set-timezone America/Chicago
```

On vérifie :

```bash
[vagrant@tp3 ~]$ timedatectl
      Local time: Fri 2020-10-09 09:22:22 CDT
  Universal time: Fri 2020-10-09 14:22:22 UTC
        RTC time: Fri 2020-10-09 14:22:20
       Time zone: America/Chicago (CDT, -0500)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: yes
 Last DST change: DST began at
                  Sun 2020-03-08 01:59:59 CST
                  Sun 2020-03-08 03:00:00 CDT
 Next DST change: DST ends (the clock jumps one hour backwards) at
                  Sun 2020-11-01 01:59:59 CDT
                  Sun 2020-11-01 01:00:00 CST
[vagrant@tp3 ~]$
```

### 3. Gestion des noms et de la résolution de noms

```bash
[vagrant@tp3 ~]$ hostnamectl
   Static hostname: tp3.b2
         Icon name: computer-vm
           Chassis: vm
        Machine ID: db7364ba82b62048b232781666245864
           Boot ID: 645067b908384d019fde0961889e28f4
    Virtualization: kvm
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-1127.19.1.el7.x86_64
      Architecture: x86-64
[vagrant@tp3 ~]$
```

Mon hostname est tp3.b2

On peut le changer dans notre Vagrantfile ou avec la commande : `sudo hostnamectl set-hostname`

On a donc :

```bash
[vagrant@tp3 ~]$ hostnamectl
   Static hostname: hello.tp3.b2
         Icon name: computer-vm
           Chassis: vm
        Machine ID: db7364ba82b62048b232781666245864
           Boot ID: 645067b908384d019fde0961889e28f4
    Virtualization: kvm
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-1127.19.1.el7.x86_64
      Architecture: x86-64
[vagrant@tp3 ~]$
```
