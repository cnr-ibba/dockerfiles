
#
# VERSION 0.5
# DOCKER-VERSION  1.9.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A django container working on LTS django 1.11 on python 3
# TO_BUILD:       docker build --rm -t django_web .
# TO_RUN:         docker run -d -P django_web
# TO_TAG:         docker tag django_web:latest django_web:0.5
#

# The official django image is deprecated in favor of the standard python image
FROM python:3.6

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

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

# Add the uwsgi.ini file (not in the volume directory)
#COPY mysite_uwsgi.ini /etc/django/uwsgi.ini

# Set uwsgi directory as VOLUME
VOLUME /var/uwsgi/

# Expose the default port
EXPOSE 8000

# This environment variable force stdin, stdout and stderr to be totally unbuffered
ENV PYTHONUNBUFFERED 1

# Execute a default command
CMD ["/bin/bash"]
