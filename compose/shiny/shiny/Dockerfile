#
# VERSION 0.2
# DOCKER-VERSION  17.05.0-ce
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A shiny container based on rocker-shiny
# TO_BUILD:       docker build --rm -t ptp/shiny .
# TO_RUN:         docker run -d -P ptp/shiny
# TO_TAG:         docker tag ptp/shiny:latest <name>:0.2
#

# Get the last rocker/shiny image
FROM rocker/shiny

# The mainteiner of this image
MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

# install package dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libxml2-dev \
    openjdk-9-jdk \
 && apt-get clean && rm -rf /var/lib/apt/lists/

# Install R packages. Packages are listed in packages.txt
COPY install.r packages.txt /root/
RUN Rscript --slave --vanilla /root/install.r

# Make sure the directory for individual app logs exists
RUN mkdir -p /var/log/shiny-server
RUN chown shiny.shiny /var/log/shiny-server

# override the defaul CMD (put stdout and stderr in docker stdout and stderr)
CMD ["shiny-server"]
