
#
# VERSION 0.2
# DOCKER-VERSION  1.6.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A nginx container to work with wordpress
# TO_BUILD:       docker build --rm -t wordpress_nginx .
# TO_RUN:         docker run -d -P wordpress_nginx
# TO_TAG:         docker tag wordpress_nginx:latest wordpress_nginx:0.1
#

# Get the last nginx image
FROM nginx:1.7

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# Copy nginx configuration file in conf.d directory
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

