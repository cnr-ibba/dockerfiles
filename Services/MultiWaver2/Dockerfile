#
# VERSION 0.1
# DOCKER-VERSION  20.10.22
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    multiwaver2 with MP support
# TO_BUILD:       docker build --rm -t bunop/multiwaver2:latest .
# TO_RUN:         docker run -ti --rm bunop/multiwaver2:latest /bin/bash
# TO_TAG:         docker tag bunop/multiwaver2:latest bunop/multiwaver2:0.1
#

# base image
FROM ubuntu:22.04

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

# upgrade and install requirements
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libboost-dev \
    libomp-dev \
    unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/

# get code from github
ADD https://github.com/Shuhua-Group/MultiWaver2.0/archive/refs/heads/master.zip /root/MultiWaver2.zip

# unpack archive
WORKDIR /root
RUN unzip MultiWaver2.zip

# compile source
WORKDIR /root/MultiWaver2.0-master/src
RUN make all

# move binary file into PATH
RUN cp -a ../bin/MultiWaveInfer2 /usr/local/bin/MultiWaver2
RUN chmod 755 /usr/local/bin/MultiWaver2

# set a final workdir
WORKDIR /
