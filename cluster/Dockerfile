
#
# VERSION 0.2
# DOCKER-VERSION  1.3.2
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A centos 7 base image with NIS configured on login.bioinformatics.tecnoparco.org using systemd
# TO_BUILD:       docker build --rm -t bunop/cluster .
# TO_RUN:         docker run -d -P --privileged --cap-add=ALL -v /sys/fs/cgroup:/sys/fs/cgroup:ro bunop/cluster
#

FROM bunop/centos7-nis

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

COPY create_user.sh /root/

# Modify sshdservice to permit root login
RUN echo "AllowUsers root" >> /etc/ssh/sshd_config

## Add some stuff here

# start the systemd process 
# find here https://github.com/2k0ri/docker-centos7-systemd.git. This is a symbolick
# link to /lib/systemd/systemd (also /sbin/init)
CMD ["/usr/sbin/init"]

