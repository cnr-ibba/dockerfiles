
# VERSION 0.1
# DOCKER-VERSION  1.5.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A centos 6 image with MySQL
# TO_BUILD:       docker build --rm -t bunop/centos6-mysql .
# TO_RUN:         docker run -d -P bunop/centos6-mysql
# TO_TAG:         docker tag bunop/centos6-mysql:latest bunop/centos6-mysql:0.1
#

# Start from a centos6 base image
FROM centos:centos6

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# install MySQL Community
RUN yum install -y mysql-server

# Initializing database
RUN /usr/bin/mysql_install_db

# Copy the configuration file
COPY my.cnf /etc/my.cnf

# expose mysql standard port
EXPOSE 3306

# run mysql
CMD ["/usr/bin/mysqld_safe"]
