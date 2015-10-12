
#
# VERSION 0.2
# DOCKER-VERSION  1.7.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    An enhanced MySQL container
# TO_BUILD:       docker build --rm -t wordpress_db .
# TO_RUN:         docker run -d -P wordpress_db
# TO_TAG:         docker tag wordpress_db:latest wordpress_db:0.2
#

# Starting from wordpress fpm (which derives from php:5.6.fpm)
FROM mysql:5.6

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# Install requeire packages fdr tuning primer
RUN apt-get update && apt-get install -y \
        net-tools \
        bc \
        less

# Clean packages and histories
RUN apt-get clean && rm -rf /var/lib/apt/lists/

# Copy tuning primer scritpt inside /usr/local/bin
COPY tuning-primer.sh /usr/local/bin/tuning-primer.sh

ENV TERM linux

# Docker entrypoint and CM are the same of the base image
