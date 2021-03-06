
# VERSION 0.1
# DOCKER-VERSION  1.5.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A centos 6 image with MySQL
# TO_BUILD:       docker build --rm -t ptp/centos6-mysql .
# TO_RUN:         docker run -d -P ptp/centos6-mysql
# TO_TAG:         docker tag ptp/centos6-mysql:latest ptp/centos6-mysql:0.1
#

# Start from a centos6 base image
FROM centos:centos6

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# install MySQL Community
RUN yum update -y && yum install -y \
    mysql-server \
    bc \
    which

# Initializing database
#RUN /usr/bin/mysql_install_db

# Copy the configuration file
COPY my.cnf /etc/my.cnf

# Copy entrypoint
COPY docker-entrypoint.sh /entrypoint.sh

# Copy tuning primer scritpt inside /usr/local/bin
COPY tuning-primer.sh /usr/local/bin/tuning-primer.sh

ENV TERM linux

# Define a volume
VOLUME /var/lib/mysql

# expose mysql standard port
EXPOSE 3306

# Define a new entripoint
ENTRYPOINT ["/entrypoint.sh"]

# run mysql
CMD ["/usr/bin/mysqld_safe"]
