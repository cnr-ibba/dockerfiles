
#
# VERSION 0.2
# DOCKER-VERSION  1.5.0
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    An image like buildpack-deps/jessie/Dockerfile
# TO_BUILD:       docker build --rm -t bunop/buildpack-deps-cluster .
# TO_RUN:         docker run -d -P --privileged --cap-add=ALL -v /sys/fs/cgroup:/sys/fs/cgroup:ro bunop/buildpack-deps-cluster
# TO_TAG:         docker tag bunop/buildpack-deps-cluster:latest bunop/buildpack-deps-cluster:0.2
#

FROM bunop/buildpack-deps-cluster-scm:0.1

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# Install Extra Packages for Enterprise Linux repository configuration (recommended)
# http://www.cyberciti.biz/faq/installing-rhel-epel-repo-on-centos-redhat-7-x/
RUN yum install -y epel-release

# install delta rmp
RUN yum install -y deltarpm

# installing packages needed to compile softwares
RUN yum groupinstall -y "Development Tools"

# install others useful files
RUN yum install -y \
    autoconf \
    ImageMagick \
    bzip2-devel \
    libcurl-devel \
    openssl-devel \
    libevent-devel \
    libffi-devel \
    glib2-devel \
    libjpeg-turbo-devel \
    xz-devel \
    ImageMagick-devel \
    mysql++-devel \
    ncurses-devel \
    libpqxx-devel \
    readline-devel \
    sqlite-devel \
    libxml2-devel \
    libxslt-devel \
    libyaml-devel \
    zlib-devel \
    gcc-c++ \
    gdbm-devel \
    tk-devel \
    db4-devel \
    libpcap-devel 
    
# Free spaces
RUN yum clean all

