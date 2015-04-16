
Create a buildpack base image to build things on PTP cluster environment
========================================================================

This guide is intended to help to construct a image like the [official repo `buildpack-deps`](https://registry.hub.docker.com/u/library/buildpack-deps/) on the top of the bunop/cluster image that work on Centos 7 NIS configured client at PTP infrastructure. As the original `buildpack-deps`, this image depends on a curl base image, in which wget, curl and ca-certificate are installed, and a scm image in which git, mercurial and subversion are installed. All additional packages to help compiling libraries have to be specified in this buildpack-deps-cluster Dockerfile or in the derived images

## Build the prerequisites

Build the bunop/cluster:0.3 image as described in [`README.md`](https://github.com/bioinformatics-ptp/dockerfiles/tree/master/cluster)

## Build the buildpack-deps-cluster-curl image

Do the following steps

```sh
$ cd curl/
$ docker build --rm -t bunop/buildpack-deps-cluster-curl .
$ docker tag bunop/buildpack-deps-cluster-curl:latest bunop/buildpack-deps-cluster-curl:0.1
$ cd ../
```

## Build the buildpack-deps-cluster-scm image

Do the following steps

```sh
$ cd scm/
$ docker build --rm -t bunop/buildpack-deps-cluster-scm .
$ docker tag bunop/buildpack-deps-cluster-scm:latest bunop/buildpack-deps-cluster-scm:0.1
$ cd ../
```

## Build the final buildpack-deps-cluster image

Do the following steps

```sh
$ docker build --rm -t bunop/buildpack-deps-cluster .
$ docker tag bunop/buildpack-deps-cluster:latest bunop/buildpack-deps-cluster:0.2
```

## Run the full buildpack-deps-cluster at PTP

You need a full privileged image in order to run systemd with openssh and NIS client

```sh
$ docker run -d -P --privileged --cap-add=ALL -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name buildpack-deps-cluster bunop/buildpack-deps-cluster 
```

Now inspect the running container to see which port listen for ssh connection and login to such port with your NIS username and password. In the following example, I saw that this container listen on port 49157:

```sh
$ docker inspect -f '{{ json .NetworkSettings }}' buildpack-deps-cluster | python -mjson.tool
$ ssh -p 49157 cozzip@localhost
```

## Bug in docker squash

I saw some strange behavior when using docker-squash, so don't squash systemd based images

