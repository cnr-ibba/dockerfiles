
#
# VERSION 0.2
# DOCKER-VERSION  1.5.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A django container working on LTS django 1.8 on python 3
# TO_BUILD:       docker build --rm -t django_web .
# TO_RUN:         docker run -d -P django_web
# TO_TAG:         docker tag django_web:latest django_web:0.2
#

FROM django:1.8-python3

# This environment variable force stdin, stdout and stderr to be totally unbuffered
ENV PYTHONUNBUFFERED 1

# Create directory for a dkango project
RUN mkdir /var/uwsgi

# Install custom modules (try it!)
# ADD requirements.txt /root/
# RUN pip install -r /root/requirements.txt

# Set corrent working directory
WORKDIR /var/uwsgi/

# Set uwsgi directory as VOLUME
VOLUME /var/uwsgi/

# Expose the default port
EXPOSE 8000

# Execute a default command
CMD ["/bin/bash"]
