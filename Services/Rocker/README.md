
Installing a rstudio image at PTP
=================================

This guide is describe how to start a rocker image on PTP infrastructure. This image start from the rocker/rstudio image, add some users to the system. All the instruction to build the base image are described in the docker file

## Add a new user

Log on your NIS server and get a lock at /etc/passwd (this file doesn't contains user password, instead contain the GID and UID for all our users). Then you can add the required instructions on Dockerfile to build a persistent image or you can log in the container with *root* account and add user inside the container. You have to add first the new group (with the correct GID) and then the correct user (with its UID). Rember to prevent the useradd interaction by using `--disabled-password` and `--gecos` options. For instance, add those line in dockerfiles:

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
$ docker tag ptp/rstudio:latest ptp/rstudio:0.4
```

## Backup a directory outside container

To backing up a directory outside rocker container (for example, to export container
home directory), you need to run a docker instance using volumes from rocker container
and volumes from a local directory, for instance:

```sh
$ docker run -it --rm --volumes-from rstudio -v $(pwd)/rstudio_volume:/data ubuntu:14.04 /bin/bash
$ cp -ra /home/* /data/
$ exit
```

## Start the image with a data volume

The data volume isn't required. Moreover it facilitates exporting users home directory between (rocker) containers.
if you set an existing directory inside a volume, you can access files outside containers. Start a new volume like this

```sh
$ docker create --name rstudio_volume \
   -v $(pwd)/rstudio_volume/:/home/ ptp/rstudio:0.4 /bin/true
```

Setting volume names facilitates process identification. Next start a new container using this volume. It could be nice also to export host localtime as stated [here](http://stackoverflow.com/questions/22800624/will-docker-container-auto-sync-time-with-the-host-machine)

```sh
$ docker run -d -p 8787:8787 -P --name rstudio --volumes-from rstudio_volume \
   -v /etc/localtime:/etc/localtime:ro -v /mnt/dell_storage/storage/:/storage/ \
   --memory="8G" --restart=always ptp/rstudio:0.4
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
```

## Restart rstudio-server inside container

To restart rstudio server (for instance, after installing packages and libraries) simply do:

```sh
$ rstudio-server stop
$ rstudio-server start
```

as *root* user inside running container (restart server doesn't works for rJava, for istance). More information about rstudio server management can be found [here](https://support.rstudio.com/hc/en-us/articles/200532327-Managing-the-Server)
