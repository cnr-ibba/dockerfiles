
FROM python:2.7

# This environment variable force stdin, stdout and stderr to be totally unbuffered
ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN pip install -r requirements.txt
ADD . /code/
