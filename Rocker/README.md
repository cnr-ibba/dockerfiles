
Installing a rstudio image at PTP
=================================

This guide is describe how to start a rocker image on PTP infrastructure. This image start from the rocker/rstudio image, add some users to the sistem and install openssh server. All the instruction to build the base image are described in the docker file

## Add a new user

Log on login server (41) and get a lock at /etc/passwd (this file doesn't contains user password, insted contain the GID and UID for all our users). Then you can add the required instruction on Dockerfile to build a persistent image or you can log in the container with root account and add user inside the container. You have to add first the new group (with the correct GID) and then the correct user (with its UID). Rember to prevent the useradd interaction by using `--disabled-password` and `--gecos` options. For instance, add those line in dockerfiles:

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
$ docker build --rm -t bunop/rstudio .
$ docker tag bunop/rstudio:latest bunop/rstudio:0.1
```

## Start the image with a data volume

The data volume isn't required. Moreover it facilitates exporting users home directory between (rocker) containers. Start a new volume like this

```sh
$ docker create --name rstudio_volume bunop/rstudio /bin/true
```

Setting volume names facilitates process identification. Next start a new container using this volume. It could be nice also to export host localtime as stated [here](http://stackoverflow.com/questions/22800624/will-docker-container-auto-sync-time-with-the-host-machine)

```sh
$ docker run -d -p 8787:8787 -P --name rstudio --volumes-from rstudio_volume -v /etc/localtime:/etc/localtime:ro -v /mnt/storage/:/storage/ bunop/rstudio
```

the `-p` options set the standard rstudio port of the container on the host. It can be omitted with the `-P` options, and docker will bind the service on another port. The `-P` option is useful to export the openssh port of the container. You can inspect the port assigned by docker by using `docker ps` or `docker inspect -f '{{ json .NetworkSettings }}' rstudio | python -mjson.tool`. The first volume exported with the `-v` option is for the HOST localtime (RO mode). The second is the storage partition, which can be modified by each user (under authentication)

If you need to rebuild the image you can re-use the previous rstudio data volumes (if the path exported is the same). Password will be resetted to their default values

## Export the docker service using NGINX

Those commands have been specified in `/etc/nginx/default.d/rstudio.conf` (in `/etc/nginx/default.d` directory there are the location defined in the server instance specified in `/etc/nginx/nginx.conf`). A copy of such configuration file is present in this directory

```
# found here https://support.rstudio.com/hc/en-us/articles/200552326-Running-with-a-Proxy
location /rstudio/ {
  rewrite ^/rstudio/(.*)$ /$1 break;
  proxy_pass http://localhost:8787;
  proxy_redirect http://localhost:8787/ $scheme://$host/rstudio/;
}
```

And then you can login tho rstudio page using this link (for instance): [http://192.168.13.7/rstudio/](http://192.168.13.7/rstudio/)

## Override the default password

To change the default password, log in Rstudio instance. Then open a new linux shell by using Tools->Shell. You can set the new password with the `passwd` command

## Enter inside volume as root

You can enter inside the rocker volume with one of the following commands:

```sh
$ docker exec -it rstudio /bin/bash
# Or
$ ssh -p <rstudio_ssh_port> root@localhost
```
