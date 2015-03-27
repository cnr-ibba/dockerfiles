
Install NIS client on docker image
==================================

This guide in intende to build a NIS docker image here at PTP. Unfortunately some steps involve a privileged access on docker resources, and at the moment those steps cannot be written in *Dockerfile* cause at the moment is not possible to build a container in privileged mode. Moreover, some processed must be running to work correctly and requires a *init* or *systemd* process to work correctly

## Run privileged container with systemd

You need to start a systemd privileged container with ADMIN and NETWORK capabilities. I found that systemd works better with the /sys/fs/cgroup so mount this folder **in read only mode**. I creared an image with systemd and openssh service, so you can use this image for your build. The following line mount /sys/fs/cgroup as a read only volume, and get **ALL** the privileges to the docker container:


```
$ docker run -d -P --privileged --cap-add=ALL -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name systemd bunop/centos7-systemd
```

Since the following doesn't expose a specific port on the server, you have find the port exposed by your image with `docker ps` or by 
`docker inspect --format='{{.NetworkSettings.Ports}}' systemd` (note that systemd is the name assigned to the container). Find out the open ssh port on the host and login as root with 


```
$ ssh -p 49166 root@localhost
```

`49166` is the port published from the container to the host

## Install requireq packages

Once inside a container, we have to do some steps:

```
$ yum -y install ypbind rpcbind authconfig hostname
$ ypdomainname BIOINFORMATICS
$ echo "NISDOMAIN=BIOINFORMATICS" >> /etc/sysconfig/network
```

