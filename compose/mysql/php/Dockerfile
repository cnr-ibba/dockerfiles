
#
# VERSION 0.3
# DOCKER-VERSION  1.5.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A nginx container to work with phpmyadmin
# TO_BUILD:       docker build --rm -t django_php .
# TO_RUN:         docker run -d -P django_php
# TO_TAG:         docker tag django_php:latest django_php:0.3
#

# Starting from wordpress fpm (which derives from php:5.6.fpm)
FROM php:5.6-fpm

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# Install modules
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        bzip2 \
        libbz2-dev \
&& docker-php-ext-install iconv mcrypt \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install gd \
&& docker-php-ext-install mbstring \
&& docker-php-ext-install mysqli \
&& docker-php-ext-install zip \
&& docker-php-ext-install bz2

# Clean packages and histories
RUN apt-get clean && rm -rf /var/lib/apt/lists/

# Install phpmyadmin
ENV PHPMYADMIN_VERSION 4.4.10

# Downloading latest phpmyadmin distribution and extract archive, rename directory and remove tar file
RUN curl -SL http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz -o /usr/src/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz \
    && tar -xvzf /usr/src/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz -C /usr/src/ \
    && mv /usr/src/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages /usr/src/phpmyadmin \
    && rm /usr/src/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz \
    && chown -R www-data:www-data /usr/src/phpmyadmin

# Override php-fpm default configuration
COPY php-fpm.conf /usr/local/etc/

# Set the phpMyAdmin config file in src directory
COPY config.inc.php /usr/src/phpmyadmin/

# docker volumes
VOLUME /var/www/html

# Copy entrypoint (as wordpress base image)
COPY docker-entrypoint.sh /entrypoint.sh

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]

# Execute commands. Such commands is executed under wordpress ENTRYPOINT
CMD ["php-fpm"]
