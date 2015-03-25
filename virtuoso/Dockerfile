FROM centos:6.4
MAINTAINER Francesco Strozzi <francesco.strozzi@gmail.com>

# Install packages
RUN yum -y install openssh-server autoconf automake libtool flex bison gperf gawk m4 make openssl-devel
# Configure SSH
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && echo 'root:dockervirtuoso' | chpasswd
RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
# Install latest Virtuoso 7
ADD v7.1.0.tar.gz /usr/local
RUN cd /usr/local/virtuoso-opensource-7.1.0 && ./autogen.sh && export CFLAGS="-O2 -m64" && ./configure --prefix=/usr/local/virtuoso-opensource-7.1.0 && make -j 4 && make install

## Install Supervisor
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y python-pip && pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor

## Set Supervisor config
ADD supervisord /etc/supervisord.conf

## Set Virtuoso management script
ADD virtuoso.sh /usr/local/bin/virtuoso.sh
RUN chmod +x /usr/local/bin/virtuoso.sh

EXPOSE 22 8890 8080
CMD ["supervisord", "-n"]
