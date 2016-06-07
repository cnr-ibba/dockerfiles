
#
# VERSION 0.4
# DOCKER-VERSION  1.7.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A rocker container with some packages and users added
# TO_BUILD:       docker build --rm -t ptp/rstudio .
# CREATE_VOLUME:  docker create --name rstudio_volume ptp/rstudio /bin/true
# TO_RUN:         docker run -d -p 8787:8787 -P --name rstudio --volumes-from rstudio_volume -v /etc/localtime:/etc/localtime:ro -v /mnt/storage/:/storage/ ptp/rstudio
# TO_TAG:         docker tag ptp/rstudio:latest ptp/rstudio:0.4
#

FROM rocker/rstudio

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

# Install required packages to compile R libraries (and others utilities)
# similar to https://registry.hub.docker.com/u/rocker/rstudio/dockerfile/
RUN rm -rf /var/lib/apt/lists/ && \
    apt-get update && \
    apt-get install -y -t unstable --no-install-recommends \
    libxml2-dev \
    apt-utils \
    apt-file \
    libmysqlclient-dev \
    libpq-dev \
    vim

# Instructions to install java JDK under rstudio image: https://github.com/cardcorp/card-rocker/blob/master/r-java/Dockerfile
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
      | tee /etc/apt/sources.list.d/webupd8team-java.list \
    &&  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
      | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
    && echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" \
        | /usr/bin/debconf-set-selections \
    && apt-get update \
    && apt-get install -y oracle-java8-installer \
    && update-alternatives --display java \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && R CMD javareconf

# Runnig rstudio instance need to be restarted (rstudio-server restart). There are no problems when building
# a new rstudio image

# Clean packages and histories
RUN apt-get clean && rm -rf /var/lib/apt/lists/

# Adding users from PTP (Read GID and UID from NIS server):
# http://askubuntu.com/questions/94060/run-adduser-non-interactively (on debian/ubuntu)
# --gecos GECOS
#       Set  the  gecos field for the new entry generated.  adduser will
#       not ask for finger information if this option is given.
# The GECOS field is a comma separated list as such: Full name,Room number,Work phone,Home phone
RUN addgroup --gid 514 cozzip && \
    adduser cozzip --uid 514 --gid 514 --disabled-password --gecos "Paolo Cozzi" && \
    echo 'cozzip:cozzip' | chpasswd

# Another user
RUN addgroup --gid 516 giannicor && \
    adduser giannicor --uid 516 --gid 516 --disabled-password --gecos "Riccardo Giannico" && \
    echo 'giannicor:giannicor' | chpasswd

# Another user
RUN addgroup --gid 506 delcorvom && \
    adduser delcorvom --uid 506 --gid 506 --disabled-password --gecos "Marcello DelCorvo" && \
    echo 'delcorvom:delcorvom' | chpasswd

# Another user
RUN addgroup --gid 521 biffanis && \
    adduser biffanis --uid 521 --gid 521 --disabled-password --gecos "Stefano Biffani" && \
    echo 'biffanis:biffanis' | chpasswd

# Another user: see that host gid is different from uid
RUN addgroup --gid 1003 lazzarib && \
    adduser lazzarib --uid 513 --gid 1003 --disabled-password --gecos "Barbara Lazzari" && \
    echo 'lazzarib:lazzarib' | chpasswd

# Another user
RUN addgroup --gid 507 nicolazzie && \
    adduser nicolazzie --uid 507 --gid 507 --disabled-password --gecos "Ezequiel Luis Nicolazzi" && \
    echo 'nicolazzie:nicolazzie' | chpasswd

# Another user
RUN addgroup --gid 505 biscarinif && \
    adduser biscarinif --uid 505 --gid 505 --disabled-password --gecos "Filippo Biscarini" && \
    echo 'biscarinif:biscarinif' | chpasswd


# Add other users here...


# Make a volume easy to export user's libraries
VOLUME /home/

# Expose the default rocker port

# Run the default rocker command
