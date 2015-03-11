
# VERSION 0.1
# DOCKER-VERSION  1.3.2
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A sshd server	
# TO_BUILD:       docker build --rm -t paolo/eg_sshd:wheezy .
# TO_RUN:         docker run -d -P paolo/eg_sshd:wheezy

FROM debian:wheezy
MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# Get local mirrors
COPY garr_sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
	apt-utils \
	openssh-server 

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
