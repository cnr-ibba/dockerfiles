
#
# VERSION 0.3
# DOCKER-VERSION  17.05.0-ce
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    A nginx container to work with django
# TO_BUILD:       docker build --rm -t django_nginx .
# TO_RUN:         docker run -d -P django_nginx
# TO_TAG:         docker tag django_nginx:latest django_nginx:0.3
#

# Get the last stable nginx image
FROM nginx:1.16

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

# Copy nginx configuration file in conf.d directory
COPY nginx.conf /etc/nginx/nginx.conf

# define NGINX volume
VOLUME /etc/nginx/conf.d/
