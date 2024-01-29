
#
# VERSION 0.5
# DOCKER-VERSION  25.0.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    A php-fpm container to work with phpmyadmin
# TO_BUILD:       docker build --rm -t wordpress_php .
# TO_RUN:         docker run -d -P wordpress_php
# TO_TAG:         docker tag wordpress_php:latest wordpress_php:0.5
#

# Starting from wordpress fpm (which derives from php:5.6.fpm)
FROM wordpress:6.4.2-fpm

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

# synchronize timezone for container
# https://forums.docker.com/t/synchronize-timezone-from-host-to-container/39116
RUN echo "Europe/Rome" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Use the default production configuration
# as suggested in https://github.com/docker-library/docs/blob/master/php/README.md#configuration
RUN mv "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"

# add a custom file
COPY "conf.d/custom.ini" "${PHP_INI_DIR}/conf.d/"
