#
# VERSION 0.1
# DOCKER-VERSION  17.05.0-ce
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A openjdk-7 image with firefox installed
# TO_BUILD:       docker build --rm -t ptp/firefox-jdk .
# TO_VOLUME:      docker create -v $PWD:/home/firefox --name firefox-jdk_volume ptp/firefox-jdk /bin/true
# TO_RUN:         docker run -ti -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --volumes-from firefox-jdk_volume --name firefox-jdk ptp/firefox-jdk
# TO_TAG:         docker tag ptp/firefox-jdk:latest ptp/firefox-jdk:0.1
#

FROM openjdk:7-jdk

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

# install firefox, then clean packages
RUN apt-get update && apt-get install -y \
    firefox-esr=45.9.0esr-1~deb8u1 \
    icedtea-7-plugin && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /tmp/* /var/tmp/*

# Add a new user
RUN useradd -m firefox

# Setting useful environment variables
WORKDIR /home/firefox/

# Set home directory as VOLUME
VOLUME /home/firefox

# Setting the user
USER firefox

# default command to reattach istance
CMD ["/usr/bin/firefox", "--no-remote"]
