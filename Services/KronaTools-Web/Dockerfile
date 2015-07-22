

# VERSION 0.1
# DOCKER-VERSION  1.6.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A nginx container to serve krona tools static files
# TO_BUILD:       docker build --rm -t web_krona_tools .
# TO_RUN:         docker run -d -P web_krona_tools
# TO_TAG:         docker tag web_krona_tools:latest web_krona_tools:0.1
#

# Get the last nginx image
FROM nginx:1.7

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# The default directory in which file will be placed
ENV CRONADIR  /usr/share/nginx/html/krona

# Krona file are provided with this container
RUN mkdir -p $CRONADIR/src
RUN mkdir -p $CRONADIR/img

# Copy ckrona directories inside krona dir
COPY krona/src $CRONADIR/src
COPY krona/img $CRONADIR/img
