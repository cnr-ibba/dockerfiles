#
# VERSION 0.1
# DOCKER-VERSION  23.0.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    A multi-stage image with python and poetry
# TO_BUILD:       docker build --rm -t bunop/python-poetry .
# TO_RUN:         docker run --rm -ti bunop/python-poetry bash
# TO_TAG:         docker tag bunop/python-poetry:latest bunop/python-poetry:0.1
#

###############################################################################
# 1st build stage

# inspired from https://bmaingret.github.io/blog/2021-11-15-Docker-and-Poetry
# Those variables are defined before the FROM scope: to use them after, recall
# ARG in build stages
ARG APP_NAME=poetry-demo
ARG APP_PATH=/opt/$APP_NAME
ARG PYTHON_VERSION=3.11
ARG POETRY_VERSION=1.3.2

FROM python:${PYTHON_VERSION} as python-build

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
COPY ${APP_NAME}/poetry.lock ${APP_NAME}/pyproject.toml ${APP_NAME}/README.md ./
COPY ${APP_NAME}/poetry_demo/ ./poetry_demo/

# Install stuff
RUN poetry install

###############################################################################
# 2nd build stage

from python:${PYTHON_VERSION} as python-runtime

# Import ARGs which I need in this build stage
# IMPORTANT!: without this redefinition, you can't use variables defined
# before the first FROM statement
ARG APP_PATH
ARG VIRTUAL_ENV=${APP_PATH}/.venv

# Set some useful variables
ENV \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1
# See https://pythonspeed.com/articles/activate-virtualenv-dockerfile/
ENV \
    VIRTUAL_ENV=${VIRTUAL_ENV} \
    PATH="${VIRTUAL_ENV}/bin:${PATH}"

# copy the application from build stage
COPY --from=python-build ${APP_PATH} ${APP_PATH}
WORKDIR ${APP_PATH}
