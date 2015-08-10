#
# VERSION 0.1
# DOCKER-VERSION  1.6.2
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A ubuntu based image to work with staden package
# TO_BUILD:       docker build --rm -t ptp/staden .
# TO_RUN:         docker run -ti -v /tmp/.X11-unix:/tmp/.X11-unix --volumes-from staden_data -e DISPLAY=$DISPLAY --name staden ptp/staden
# TO_TAG:         docker tag ptp/staden:latest ptp/staden:0.1
#

FROM ubuntu:14.04

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# Update image
RUN apt-get update && apt-get upgrade -y

# Install useful packages
RUN apt-get install -y \
    wget \
    libxft2 \
    libxss1 \
    build-essential \
    libcurl3

# Clean up APT cache
RUN apt-get clean && apt-get autoclean && rm -rf /tmp/* /var/tmp/*

# Setting a new workdir
WORKDIR /root/

# Download and Install staden package
RUN wget http://downloads.sourceforge.net/project/staden/staden/2.0.0b10/staden-2.0.0b10-linux-x86_64.tar.gz
RUN tar -xvzf staden-2.0.0b10-linux-x86_64.tar.gz

# Copying files inside /usr/local/ location
RUN cp -ra staden-2.0.0b10-linux-x86_64/bin/*  /usr/local/bin/ && \
    cp -ra staden-2.0.0b10-linux-x86_64/include/* /usr/local/include/ && \
    cp -ra staden-2.0.0b10-linux-x86_64/lib/* /usr/local/lib/ && \
    cp -ra staden-2.0.0b10-linux-x86_64/man/* /usr/local/man && \
    cp -ra staden-2.0.0b10-linux-x86_64/share/* /usr/local/share/

# Install also caftools
RUN wget ftp://ftp.sanger.ac.uk/pub/resources/software/caf/caftools-2.0.2.tar.gz
RUN tar -xvzf caftools-2.0.2.tar.gz

# Setting a new workdir
WORKDIR /root/caftools-2.0.2/

# Compile and install
RUN ./configure && make && make install

# Setting the final workdir
WORKDIR /root/

# Add a new user
RUN useradd -m staden

# Setting useful environment variables
WORKDIR /home/staden/

# Set home directory as VOLUME
VOLUME /home/staden

# Setting the user
USER staden

# default command to reattach istance
CMD ["/bin/bash"]
