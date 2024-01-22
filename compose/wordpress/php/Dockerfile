
#
# VERSION 0.5
# DOCKER-VERSION  25.0.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    A nginx container to work with wordpress
# TO_BUILD:       docker build --rm -t wordpress_php .
# TO_RUN:         docker run -d -P wordpress_php
# TO_TAG:         docker tag wordpress_php:latest wordpress_php:0.5
#

ARG WORDPRESS_VERSION=6.4.2-fpm

# Starting from wordpress fpm (which derives from php:5.6.fpm)
FROM wordpress:${WORDPRESS_VERSION}

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

# Override php-fpm default configuration
COPY php-fpm.conf /usr/local/etc/

# Add a new php configuration for additional parameters
COPY php.ini /usr/local/etc/php/conf.d/

# docker volumes
VOLUME /var/www/html
