
#
# VERSION 0.4
# DOCKER-VERSION  1.5.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A django container working on LTS django 1.8 on python 3
# TO_BUILD:       docker build --rm -t django_web .
# TO_RUN:         docker run -d -P django_web
# TO_TAG:         docker tag django_web:latest django_web:0.4
#

FROM django:1.8-python3

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# This environment variable force stdin, stdout and stderr to be totally unbuffered
ENV PYTHONUNBUFFERED 1

# Create directory for a django project
RUN mkdir /var/uwsgi

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpcre3 \
    libpcre3-dev

# Clean packages and histories
RUN apt-get clean && rm -rf /var/lib/apt/lists/
    
# Install custom modules (uwsgi)
COPY requirements.txt /root/
RUN pip install -r /root/requirements.txt

# Set corrent working directory
WORKDIR /var/uwsgi/

# Add the uwsgi.ini file (not in the volume directory)
COPY mysite_uwsgi.ini /etc/django_uwsgi.ini

# Set uwsgi directory as VOLUME
VOLUME /var/uwsgi/

# Expose the default port
EXPOSE 8000

# Execute a default command
CMD ["/bin/bash"]
