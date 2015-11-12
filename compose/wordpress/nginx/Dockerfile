
#
# VERSION 0.4
# DOCKER-VERSION  1.7.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A nginx container to work with wordpress
# TO_BUILD:       docker build --rm -t wordpress_nginx .
# TO_RUN:         docker run -d -P wordpress_nginx
# TO_TAG:         docker tag wordpress_nginx:latest wordpress_nginx:0.4
#

# Get the last nginx image
FROM ubuntu:trusty

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

ENV NGINX_VERSION nginx/1.8.0~rtcamp

# Install nginx-full (https://rtcamp.com/tutorials/linux/ubuntu-php-mysql-nginx-postfix/)
RUN apt-get update && apt-get install -y \
    ca-certificates \
    software-properties-common \
 && add-apt-repository ppa:rtcamp/nginx \
 && apt-get update \
 && apt-get install -y nginx-custom \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add nginx user (https://www.linode.com/docs/websites/nginx/how-to-install-nginx-on-debian-7-wheezy)
RUN adduser --system --no-create-home --disabled-login --disabled-password --group nginx
 
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# default ports
EXPOSE 80 443

# Copy nginx configuration file in conf.d directory
COPY nginx.conf /etc/nginx/nginx.conf

# configuration directory
VOLUME /etc/nginx/conf.d/

CMD ["nginx", "-g", "daemon off;"]
