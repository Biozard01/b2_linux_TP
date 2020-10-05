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

```

## 3. Création d'un service

### A. Serveur web
