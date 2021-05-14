
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
FROM perl:5.32

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

# Install mirdeep2 requirements
RUN cpanm https://cpan.metacpan.org/authors/id/S/SS/SSIMMS/PDF-API2-2.029.tar.gz

# download mirdeep2 using git
RUN git clone https://github.com/rajewsky-lab/mirdeep2 /opt/mirdeep2/

WORKDIR /opt/mirdeep2/

# Exporting variables
ENV PATH="/opt/mirdeep2/bin:${PATH}"

# create mirdeep2 bin directory (using install) and install stuff
RUN perl install.pl && perl install.pl
