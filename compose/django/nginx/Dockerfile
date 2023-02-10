
#
# VERSION 0.4
# DOCKER-VERSION  23.0.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    A nginx container to work with django
# TO_BUILD:       docker build --rm -t django_nginx .
# TO_RUN:         docker run -d -P django_nginx
# TO_TAG:         docker tag django_nginx:latest django_nginx:0.4
#

# Get the last stable nginx image
FROM nginx:1.23

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

# synchronize timezone for container
# https://forums.docker.com/t/synchronize-timezone-from-host-to-container/39116
RUN echo "Europe/Rome" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Copy nginx configuration file in conf.d directory
COPY nginx.conf /etc/nginx/nginx.conf

# define NGINX volume
VOLUME /etc/nginx/conf.d/
