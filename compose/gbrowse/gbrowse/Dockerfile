
#
# VERSION 0.1
# DOCKER-VERSION  17.05.0-ce
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A http container to work with gbrowse
# TO_BUILD:       docker build --rm -t gbrowse_gbrowse .
# TO_RUN:         docker run -d -P gbrowse_gbrowse
# TO_TAG:         docker tag gbrowse_gbrowse:latest gbrowse_gbrowse:0.1
#

# Get the latest gbrowse image
FROM comics/gbrowse

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

# overwrite log files (https://serverfault.com/a/711172)
RUN ln -sf /proc/self/fd/1 /var/log/httpd/access_log && \
    ln -sf /proc/self/fd/2 /var/log/httpd/error_log

# expose ports
EXPOSE 80
EXPOSE 443

# uset entrypoint
ENTRYPOINT []

# execute apache in foreground
CMD ["apachectl", "-DFOREGROUND"]
