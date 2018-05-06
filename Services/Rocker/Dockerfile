
#
# VERSION 0.8
# DOCKER-VERSION  17.05.0-ce
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A rocker container with some packages and users added
# TO_BUILD:       docker build --rm -t ptp/rstudio .
# TO_TAG:         docker tag ptp/rstudio:latest ptp/rstudio:0.8
# CREATE_VOLUME:  docker create --name rstudio_volume ptp/rstudio:0.8 /bin/true
# TO_RUN:         docker run -d -p 8787:8787 -P --name rstudio --volumes-from rstudio_volume -v /etc/localtime:/etc/localtime:ro -v /mnt/storage/:/storage/ ptp/rstudio:0.8
#

FROM rocker/rstudio

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

# Install required packages to compile R libraries (and others utilities)
# similar to https://registry.hub.docker.com/u/rocker/rstudio/dockerfile/
RUN rm -rf /var/lib/apt/lists/ && \
    apt-get update && \
    apt-get install -y \
    libxml2-dev \
    apt-utils \
    apt-file \
    libmariadbclient-dev \
    libpq-dev \
    vim \
    nano \
    libgmp-dev \
    ghostscript \
    debian-ports-archive-keyring \
    pandoc \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-latex-recommended \
    texlive-latex-extra && \
    openjdk-9-jdk && \
    apt-get clean && rm -rf /var/lib/apt/lists/

# Runnig rstudio instance need to be restarted (rstudio-server restart). There are no problems when building
# a new rstudio image

# copy sources.list with deb-src packages
COPY sources.list /etc/apt/sources.list

# add X11 libraries to build rgl package
RUN apt-get update \
    && apt-get -y build-dep rgl \
    && apt-get clean && rm -rf /var/lib/apt/lists/

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
RUN addgroup --gid 505 biscarinif && \
    adduser biscarinif --uid 505 --gid 505 --disabled-password --gecos "Filippo Biscarini" && \
    echo 'biscarinif:biscarinif' | chpasswd

# Another user
RUN addgroup --gid 533 masettig && \
    adduser masettig --uid 533 --gid 533 --disabled-password --gecos "Giulia Masetti" && \
    echo 'masettig:masettig' | chpasswd

# Add other users here...

# Add groups and users to groups
RUN addgroup --gid 1002 ngs && \
    usermod -a -G ngs cozzip && \
    usermod -a -G ngs giannicor && \
    usermod -a -G ngs lazzarib && \
    usermod -a -G ngs biscarinif

# By default RStudio Server only allows normal (as opposed to system) users to
# successfully authenticate. The minimum user id is determined by reading the
# UID_MIN value from the /etc/login.defs file. If the file doesn’t exist or
# UID_MIN isn’t defined within it then a default value of 1000 is used.
# You change the minimum user id by specifying the auth-minimum-user-id option in
# /etc/rstudio/rserver.conf
COPY rserver.conf /etc/rstudio/rserver.conf

# Make a volume easy to export user's libraries
VOLUME /home/

# Expose the default rocker port

# Run the default rocker command
