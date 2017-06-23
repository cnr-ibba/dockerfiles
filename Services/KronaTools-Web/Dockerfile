

# VERSION 0.2
# DOCKER-VERSION  17.05.0-ce
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A nginx container to serve krona tools static files
# TO_BUILD:       docker build --rm -t ptp/web_krona_tools .
# TO_RUN:         docker run -d --publish 10080:80 --name web_krona_tools ptp/web_krona_tools 
# TO_TAG:         docker tag ptp/web_krona_tools:latest ptp/web_krona_tools:0.2
#

# Get the last nginx image
FROM nginx:1.11

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

# The default directory in which file will be placed
ENV CRONADIR  /usr/share/nginx/html/krona

# Krona file are provided with this container
RUN mkdir -p $CRONADIR

# Copy ckrona directories inside krona dir
COPY krona $CRONADIR
