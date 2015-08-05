
Installing a rstudio image at PTP
=================================

This guide is describe how to start a rocker image on PTP infrastructure. This image start from the rocker/rstudio image, add some users to the sistem and install openssh server. All the instruction to build the base image are described in the docker file

## Add a new user

Log on login server (41) and get a lock at /etc/passwd (this file doesn't contains user password, insted contain the GID and UID for all our users). Then you can add the required instruction on Dockerfile to build a persistent image or you can log in the container with *root* account and add user inside the container. You have to add first the new group (with the correct GID) and then the correct user (with its UID). Rember to prevent the useradd interaction by using `--disabled-password` and `--gecos` options. For instance, add those line in dockerfiles:

```
# Adding users from PTP (Read GID and UID from NIS server):
# http://askubuntu.com/questions/94060/run-adduser-non-interactively (on debian/ubuntu)
# --gecos GECOS
#       Set  the  gecos field for the new entry generated.  adduser will
#       not ask for finger information if this option is given.
# The GECOS field is a comma separated list as such: Full name,Room number,Work phone,Home phone
RUN addgroup --gid 514 cozzip && \
    adduser cozzip --uid 514 --gid 514 --disabled-password --gecos "Paolo Cozzi" && \
    echo 'cozzip:cozzip' | chpasswd
```

## Build the rocker image

Build a rocker image with a command like this:

```sh
$ docker build --rm -t ptp/rstudio .
$ docker tag ptp/rstudio:latest ptp/rstudio:0.3
```

## Start the image with a data volume

The data volume isn't required. Moreover it facilitates exporting users home directory between (rocker) containers.
if you set an exististing directory insider a volume, you can access files outside containers. Start a new volume like this

```sh
$ docker create --name rstudio_volume \
   -v /mnt/dell_storage/cloud/docker/rstudio_volume/:/home/ ptp/rstudio /bin/true
```

Setting volume names facilitates process identification. Next start a new container using this volume. It could be nice also to export host localtime as stated [here](http://stackoverflow.com/questions/22800624/will-docker-container-auto-sync-time-with-the-host-machine)

```sh
$ docker run -d -p 8787:8787 -P --name rstudio --volumes-from rstudio_volume \
   -v /etc/localtime:/etc/localtime:ro -v /mnt/dell_storage/storage/:/storage/ \
   --cpuset-cpus=0-8 --memory="8G" ptp/rstudio
```

the `-p` options set the standard rstudio port of the container on the host. It can be omitted with the `-P` options, and docker will bind the service on another port. The `-P` option is useful to export the openssh port of the container. With the `--cpuset-cpus` you can set a CPU interval in which the application can run. Unfortunately at the moment it seems impossible to set CPU dinamically. With the `--memory` option you can set the memory to allocate. You can specify a numeric value with a dimension like M for Mb, G for GB, and so on. More information about docker resource usage can be found [here](https://gist.github.com/afolarin/15d12a476e40c173bf5f).
You can inspect the port assigned by docker by using `docker ps` or `docker inspect -f '{{ json .NetworkSettings }}' rstudio | python -mjson.tool`. The first volume exported with the `-v` option is for the HOST localtime (RO mode). The second is the storage partition, which can be modified by each user (under authentication)

If you need to rebuild the image you can re-use the previous rstudio data volumes (if the path exported is the same). Password will be resetted to their default values

## Export the docker service using NGINX

Those commands have been specified in `/etc/nginx/default.d/rstudio.conf` (in `/etc/nginx/default.d` directory there are the location defined in the server instance specified in `/etc/nginx/nginx.conf`). A copy of such configuration file is present in this directory

```
# found here https://support.rstudio.com/hc/en-us/articles/200552326-Running-with-a-Proxy
location /rstudio/ {
  rewrite ^/rstudio/(.*)$ /$1 break;
  proxy_pass http://localhost:8787;

  #with a redirect to $scheme://$http_host link are constructed using client host,
  so also tunnels works (eg. localhost:10080)
  proxy_redirect http://localhost:8787/ $scheme://$http_host/rstudio/;
}
```

And then you can login to the rstudio page using this link (for instance): [http://192.168.13.150/rstudio/](http://192.168.13.150/rstudio/)

## Override the default password

To change the default password, log in Rstudio instance. Then open a new linux shell by using Tools->Shell. You can set the new password with the `passwd` command

## Enter inside volume as *root*

You can enter inside the rocker volume with one of the following commands:

```sh
$ docker exec -it rstudio /bin/bash
# Or
$ ssh -p <rstudio_ssh_port> root@localhost
```

## Automatically start Rstudio container

You can set the [--restart](https://docs.docker.com/reference/run/#restart-policies-restart) option during `docker run` instance to automatically restart a container. To automatically start a container during system startup, you can configure `systemd ` as described [here](https://docs.docker.com/articles/host_integration/#automatically-start-containers). [This](http://linuxaria.com/article/an-introduction-to-systemd-for-centos-7?lang=it) is a nice introduction to `systemd` phylosopy and [here](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/sect-Managing_Services_with_systemd-Unit_Files.html) ther is the offical Centos 7 documentation on writing systemd configure file. Now start by create a custom file in `/etc/systemd/system/` directory and set the permissions

```sh
$ touch /etc/systemd/system/rstudio_server.service
$ chmod 664 /etc/systemd/system/rstudio_server.service
```
Now edit the file according to contaner name:

```conf
[Unit]
Description=RStudio server docker container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a rstudio
ExecStop=/usr/bin/docker stop -t 2 rstudio

[Install]
WantedBy=local.target
```

Now you have to reload all configuration for systemd, and start the service in order to get a systemd process id:

```sh
$ systemctl daemon-reload
$ systemctl start rstudio_server
$ systemctl status rstudio_server

```

You may see a status like this:

```
rstudio_server.service - RStudio server docker container
   Loaded: loaded (/etc/systemd/system/rstudio_server.service; disabled)
   Active: active (running) since mer 2015-07-22 10:59:14 CEST; 2s ago
 Main PID: 144397 (docker)
   CGroup: /system.slice/rstudio_server.service
           └─144397 /usr/bin/docker start -a rstudio
```

## Restart rstudio-server inside container

To restart rstudio server (for instance, after installing packages and libraries) simply do:

```sh
$ rstudio-server stop
$ rstudio-server start
```

as *root* user inside running container (restart server doesn't works for rJava, for istance). More information about rstudio server management can be found [here](https://support.rstudio.com/hc/en-us/articles/200532327-Managing-the-Server)
