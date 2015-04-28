
#
# VERSION 0.1
# DOCKER-VERSION  1.5.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A nginx container to work with django
# TO_BUILD:       docker build --rm -t django_nginx .
# TO_RUN:         docker run -d -P django_nginx
# TO_TAG:         docker tag django_nginx:latest django_nginx:0.1
#

# Get the last nginx image
FROM nginx:1.7

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# Copy nginx configuration file in conf.d directory
COPY nginx.conf /etc/nginx/nginx.conf
COPY mysite_nginx.conf /etc/nginx/conf.d/default.conf

