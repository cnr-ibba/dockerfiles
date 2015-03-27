
Install NIS client on docker image
==================================

This guide in intende to build a NIS docker image here at PTP. Unfortunately some steps involve a privileged access on docker resources, and at the moment those steps cannot be written in *Dockerfile* cause at the moment is not possible to build a container in privileged mode. Moreover, some processed must be running to work correctly and requires a *init* or *systemd* process to work correctly

## Run privileged container with systemd

You need to start a systemd privileged container with ADMIN and NETWORK capabilities. I found that systemd works better with the /sys/fs/cgroup so mount this folder **in read only mode**. I creared an image with systemd and openssh service, so you can use this image for your build. The following line mount /sys/fs/cgroup as a read only volume, and get **ALL** the privileges to the docker container:

```sh
$ docker run -d -P --privileged --cap-add=ALL -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name systemd bunop/centos7-systemd
```
Since the following doesn't expose a specific port on the server, you have find the port exposed by your image with `docker ps` or by 
`docker inspect --format='{{.NetworkSettings.Ports}}' systemd` (note that systemd is the name assigned to the container). Find out the open ssh port on the host and login as root with 

```sh
$ ssh -p 49166 root@localhost
```

`49166` is the port published from the container to the host

## Install requireq packages

Once inside a container, we have to do some steps:

```sh
$ yum -y install ypbind rpcbind authconfig hostname
$ ypdomainname BIOINFORMATICS
$ echo "NISDOMAIN=BIOINFORMATICS" >> /etc/sysconfig/network
$ echo -e "192.168.13.41\tlogin.bioinformatics.tecnoparco.org" >> /etc/hosts

# Setting locales: http://jaredmarkell.com/docker-and-locales/
$ localectl set-locale LANG=it_IT.UTF-8 
$ localectl set-keymap it2
$ export LANG=it_IT.UTF-8
$ export LANGUAGE=it_IT.it
$ export LC_ALL=en_US.UTF-8
$ authconfig --enablenis --nisdomain=BIOINFORMATICS --nisserver=login.bioinformatics.tecnoparco.org --enablemkhomedir --update
$ systemctl enable rpcbind ypbind
$ systemctl start rpcbind ypbind
```

## Fix the /etc/host question

Now there is only one problem to fix: We can modify /etc/hosts but all changes will be wiped out, even with docker pull. So we have to add the login string on all system startup. A solution could be to write it when system start, so

```sh
$ chmod +x /etc/rc.d/rc.local
```

Now edit the rc.local script to add the following line:

```sh
# Add the NIS server at the bottom of /etc/hosts
echo -e "192.168.13.41\tlogin.bioinformatics.tecnoparco.org" >> /etc/hosts
```

## restart docker container and test it

Now log out, shutdown the container and restart it. Then gent the new ssh port and test NIS configuration:

```sh
$ docker stop systemd
$ docker start systemd
$ ssh -p 49173 root@localhost
```
where `49173` is the port published from the container to the host. Once logged, try to get NIS domainname with `ypwhich`: you have to see the configure domainname in output. 

## Create a base image

Next log out or shutdown the system (you have installed a full systemd image). The commit the container to local docker repository:

```sh
docker commit -a "Paolo Cozzi" -m "Centos 7 + systemd + NIS client configured" systemd bunop/centos7-nis
```
