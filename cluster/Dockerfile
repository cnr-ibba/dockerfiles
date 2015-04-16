
#
# VERSION 0.3
# DOCKER-VERSION  1.5.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A centos 7 base image with NIS configured on login.bioinformatics.tecnoparco.org using systemd
# TO_BUILD:       docker build --rm -t bunop/cluster .
# TO_RUN:         docker run -d -P --privileged --cap-add=ALL -v /sys/fs/cgroup:/sys/fs/cgroup:ro bunop/cluster
# TO_TAG:         docker tag bunop/cluster:latest bunop/cluster:0.3
#

FROM bunop/centos7-nis

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

## Add some stuff here

# start the systemd process 
# find here https://github.com/2k0ri/docker-centos7-systemd.git. This is a symbolick
# link to /lib/systemd/systemd (also /sbin/init)
CMD ["/usr/sbin/init"]
