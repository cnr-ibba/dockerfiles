
#
# VERSION 0.1
# DOCKER-VERSION  1.6.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    An enhanced MySQL container
# TO_BUILD:       docker build --rm -t bunop/mysql .
# TO_RUN:         docker run -d -P bunop/mysql
# TO_TAG:         docker tag bunop/mysql:latest bunop/mysql:0.1
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
