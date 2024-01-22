
#
# VERSION 0.5
# DOCKER-VERSION  25.0.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    A nginx container to work with wordpress
# TO_BUILD:       docker build --rm -t wordpress_nginx .
# TO_RUN:         docker run -d -P wordpress_nginx
# TO_TAG:         docker tag wordpress_nginx:latest wordpress_nginx:0.5
#

# Get the last nginx image
FROM nginx:1.25

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
