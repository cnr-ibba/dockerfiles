
#
# VERSION 0.1
# DOCKER-VERSION  1.5.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A nginx container to work with phpmyadmin
# TO_BUILD:       docker build --rm -t django_php .
# TO_RUN:         docker run -d -P django_php
# TO_TAG:         docker tag django_php:latest django_php:0.1
#

# Starting from the example seen at: https://registry.hub.docker.com/_/php/
FROM php:5.6-fpm

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# Install modules
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# Install phpmyadmin

# Clean packages

# Override default configuration
COPY php-fpm.conf /usr/local/etc/

# docker volumes
VOLUME /var/www/html

# Execute commands
CMD ["php-fpm"]
