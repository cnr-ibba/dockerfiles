
#
# VERSION 0.3
# DOCKER-VERSION  17.05.0-ce
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A mysql container to work with gbrowse
# TO_BUILD:       docker build --rm -t gbrowse_db .
# TO_RUN:         docker run -d -P gbrowse_db
# TO_TAG:         docker tag gbrowse_db:latest gbrowse_db:0.3
#

# Starting from mysql base image
FROM mysql:5.7

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

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
