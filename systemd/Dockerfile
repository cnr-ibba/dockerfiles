
FROM centos:7

# Inspired from Here:
# https://rhatdan.wordpress.com/2014/04/30/running-systemd-within-a-docker-container/

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

ENV container docker

# Commented out 
# RUN yum remove -y fakesystemd
# RUN yum install -y systemd \
#     device-mapper \
#     device-mapper-libs \
#     iptables \
#     iputils \
#     kpartx

# find here https://github.com/2k0ri/docker-centos7-systemd.git
RUN yum swap -y fakesystemd systemd

RUN yum -y install openssh-server; systemctl enable sshd.service

RUN mkdir /var/run/sshd
RUN echo 'root:systemd' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Free spaces
RUN yum clean all

VOLUME [ "/sys/fs/cgroup" ]

# Ports to expose
EXPOSE 22

# The only process to instantiate is init (systemd)
CMD [ "/usr/sbin/init" ]
