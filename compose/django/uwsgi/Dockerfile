
#
# VERSION 0.6
# DOCKER-VERSION  17.05.0-ce
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    A django container working on LTS django 2.2 on python 3
# TO_BUILD:       docker build --rm -t django_uwsgi .
# TO_RUN:         docker run -d -P django_uwsgi
# TO_TAG:         docker tag django_uwsgi:latest django_uwsgi:0.6
#

# The official django image is deprecated in favor of the standard python image
FROM python:3.7

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    mysql-client \
    sqlite3 && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

# Create directory for a django project
RUN mkdir /var/uwsgi/

# Install custom modules (uwsgi)
COPY requirements.txt /root/
RUN pip install -r /root/requirements.txt

# Set corrent working directory
WORKDIR /var/uwsgi/

# Set uwsgi directory as VOLUME
VOLUME /var/uwsgi/

# Expose the default port
EXPOSE 8000

# This environment variable force stdin, stdout and stderr to be totally unbuffered
ENV PYTHONUNBUFFERED 1

# Execute a default command
CMD ["/bin/bash"]
