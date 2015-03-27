
#
# VERSION 0.1
# DOCKER-VERSION  1.3.2
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A centos 7 base image with systemd support
# TO_BUILD:       docker build --rm -t bunop/centos7-systemd:test .
# TO_RUN:         docker run -d -P --privileged --cap-add=ALL -v /sys/fs/cgroup:/sys/fs/cgroup:ro bunop/centos7-systemd:test
#

# I've found some useful post to run a systemd in privileged containers
# https://rhatdan.wordpress.com/2014/04/30/running-systemd-within-a-docker-container/
# https://github.com/2k0ri/docker-centos7-systemd
# Now I want to integrate all the information to create a full systemd container
# This image MUST be run in a privileged container

# Start from a centos7 base image
FROM centos:centos7

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# systemd likes to know that it is running within a container, and it checks the container
# environment variable for this.  The ENV will cause the “container” environment variable to be set.
ENV container docker

# find here https://github.com/2k0ri/docker-centos7-systemd.git
# This will substitute the default systemd of docker-centos7 container with a full
# systemd with all its capabilities
RUN yum swap -y fakesystemd systemd

# Install and enable SSHD service
RUN yum -y install openssh-server \
	openssh-clients \
	policycoreutils \
	rsync

# Enable sshd service (it will start when starting container)
RUN systemctl enable sshd.service

# The enable root login over ssh and set a default password. Come from:
# https://docs.docker.com/examples/running_ssh_service/
RUN mkdir /var/run/sshd
RUN echo 'root:systemd' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Free spaces (disabled at the moment)
# RUN yum clean all

# Setting locales: http://jaredmarkell.com/docker-and-locales/
# RUN localectl set-locale LANG=it_IT.UTF-8 && localectl set-keymap it2
RUN localectl set-locale LANG=it_IT.UTF-8
ENV LANG it_IT.UTF-8
ENV LANGUAGE it_IT.it
ENV LC_ALL en_US.UTF-8  

# Ports to expose. At least the 22 ssh port
EXPOSE 22

# systemd insists on looking at the cgroup file system within a container.  I added
# the cgroup file system to the container  using the Volume mount as stated in
# https://rhatdan.wordpress.com/2014/04/30/running-systemd-within-a-docker-container/
# remember to mount this directory in RO mode!!! ex: -v /sys/fs/cgroup:/sys/fs/cgroup:ro
VOLUME [ "/sys/fs/cgroup" ]

# find here https://github.com/2k0ri/docker-centos7-systemd.git. This is a symbolick
# link to /lib/systemd/systemd (also "/usr/sbin/init)
CMD ["/sbin/init", "3"]
