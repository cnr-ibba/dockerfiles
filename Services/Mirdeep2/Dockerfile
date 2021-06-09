
#
# VERSION 0.1
# DOCKER-VERSION  20.10.6
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    Mirdeep 2 container image
# TO_BUILD:       docker build --rm -t mirdeep2 .
# TO_RUN:         docker run -ti --rm mirdeep2 /bin/bash
# TO_TAG:         docker tag mirdeep2:latest mirdeep2:0.1
#

# FROM <image>[:<tag>|@<digest]
FROM buildpack-deps:buster

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

# upgrade and install perl
RUN apt-get update && \
    apt-get install -y \
    perl \
    cpanminus && \
    apt-get clean && rm -rf /var/lib/apt/lists/

# Install mirdeep2 requirements
RUN cpanm PDF::API2

# download mirdeep2 using git
RUN git clone https://github.com/rajewsky-lab/mirdeep2 /opt/mirdeep2/

WORKDIR /opt/mirdeep2/

# create mirdeep2 bin directory (using install)
RUN perl install.pl

# Exporting variables
ENV PATH="/opt/mirdeep2/bin:${PATH}"
ENV PERL_MB_OPT="--install_base /root/perl5"
ENV PERL_MM_OPT="INSTALL_BASE=/root/perl5"
ENV PERL5LIB="/opt/mirdeep2/lib/perl5"

# install stuff
RUN perl install.pl
