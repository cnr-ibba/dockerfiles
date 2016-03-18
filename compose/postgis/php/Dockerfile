
#
# VERSION 0.1
# DOCKER-VERSION  1.9.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A nginx container to work with phppgadmin
# TO_BUILD:       docker build --rm -t postgis_php .
# TO_RUN:         docker run -d -P postgis_php
# TO_TAG:         docker tag postgis_php:latest postgis_php:0.1
#

# Starting from wordpress fpm (which derives from php:5.6.fpm)
FROM php:5.6-fpm

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

# Install modules
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        mcrypt \
        libmcrypt-dev \
        libpng12-dev \
        bzip2 \
        libbz2-dev \
        libpq-dev \
&& docker-php-ext-install iconv mcrypt \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install gd \
&& docker-php-ext-install mbstring \
&& docker-php-ext-install pgsql \
&& docker-php-ext-install zip \
&& docker-php-ext-install bz2

# Clean packages and histories
RUN apt-get clean && rm -rf /var/lib/apt/lists/

# Install phpmyadmin
ENV PHPPGADMIN_VERSION REL_5-1-0

# Downloading latest phpmyadmin distribution and extract archive, rename directory and remove tar file
RUN curl -SL https://github.com/phppgadmin/phppgadmin/archive/${PHPPGADMIN_VERSION}.tar.gz -o /usr/src/phppgadmin-${PHPPGADMIN_VERSION}.tar.gz \
    && tar -xvzf /usr/src/phppgadmin-${PHPPGADMIN_VERSION}.tar.gz -C /usr/src/ \
    && mv /usr/src/phppgadmin-${PHPPGADMIN_VERSION} /usr/src/phppgadmin \
    && rm /usr/src/phppgadmin-${PHPPGADMIN_VERSION}.tar.gz \
    && chown -R www-data:www-data /usr/src/phppgadmin

# Override php-fpm default configuration
COPY php-fpm.conf /usr/local/etc/

# Set the phpMyAdmin config file in src directory
COPY config.inc.php /usr/src/phppgadmin/conf/

# docker volumes
VOLUME /var/www/html

# Copy entrypoint (as wordpress base image)
COPY docker-entrypoint.sh /entrypoint.sh

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]

# Execute commands. Such commands is executed under wordpress ENTRYPOINT
CMD ["php-fpm"]
