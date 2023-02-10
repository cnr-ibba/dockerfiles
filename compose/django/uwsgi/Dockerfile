
#
# VERSION 0.7
# DOCKER-VERSION  23.0.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    A django container working on django 4.1 on python 3.11
# TO_BUILD:       docker build --rm -t django_uwsgi -f Dockerfile ..
# TO_RUN:         docker run -d -P django_uwsgi
# TO_TAG:         docker tag django_uwsgi:latest django_uwsgi:0.7
#

###############################################################################
# 1st build stage

# inspired from https://bmaingret.github.io/blog/2021-11-15-Docker-and-Poetry
# Those variables are defined before the FROM scope: to use them after, recall
# ARG in build stages
ARG APP_NAME=mysite
ARG APP_PATH=/opt/$APP_NAME
ARG PYTHON_VERSION=3.11
ARG POETRY_VERSION=1.3.2

FROM python:${PYTHON_VERSION}

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

# Import ARGs which I need in this build stage
# IMPORTANT!: without this redefinition, you can't use variables defined
# before the first FROM statement
ARG POETRY_VERSION
ARG APP_NAME
ARG APP_PATH

# Set some useful variables
ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1
ENV \
    POETRY_VERSION=${POETRY_VERSION} \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1

# Install Poetry - require $POETRY_VERSION & $POETRY_HOME environment variables
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python
ENV PATH="$POETRY_HOME/bin:$PATH"

# CREATE APP_PATH
RUN mkdir -p ${APP_PATH}
WORKDIR ${APP_PATH}

# Need to copy all the files declared in pyproject.toml
COPY ../poetry.lock ../pyproject.toml ../README.md ./

# Install stuff
RUN poetry install

###############################################################################
# 2nd build stage

from python:${PYTHON_VERSION}-slim

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

# Import ARGs which I need in this build stage
# IMPORTANT!: without this redefinition, you can't use variables defined
# before the first FROM statement
ARG APP_PATH
ARG VIRTUAL_ENV=${APP_PATH}/.venv

# synchronize timezone for container
# https://forums.docker.com/t/synchronize-timezone-from-host-to-container/39116
RUN echo "Europe/Rome" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# install required packages
RUN apt-get update && apt-get install -y \
    libmariadb3 \
    libxml2 \
    && rm -rf /var/lib/apt/lists/*

# Set some useful variables
ENV \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1
# See https://pythonspeed.com/articles/activate-virtualenv-dockerfile/
ENV \
    VIRTUAL_ENV=${VIRTUAL_ENV} \
    PATH="${VIRTUAL_ENV}/bin:${PATH}"

# utility script to ensure that mysql server is up
# mind to the context path
COPY uwsgi/wait-for-mysql.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/wait-for-mysql.sh

# copy the application from build stage
COPY --from=0 ${APP_PATH} ${APP_PATH}
WORKDIR ${APP_PATH}

# Set uwsgi directory as VOLUME
VOLUME ${APP_PATH}

# Expose the default port
EXPOSE 8000

# This environment variable force stdin, stdout and stderr to be totally unbuffered
ENV PYTHONUNBUFFERED 1

# Execute a default command
CMD ["/bin/bash"]
