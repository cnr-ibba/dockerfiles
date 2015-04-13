
#
# VERSION 0.1
# DOCKER-VERSION  1.3.2
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A python 2.7 image working on  login.bioinformatics.tecnoparco.org using systemd
# TO_BUILD:       docker build --rm -t bunop/cluster-python .
# TO_RUN:         docker run -d -P --privileged --cap-add=ALL -v /sys/fs/cgroup:/sys/fs/cgroup:ro bunop/cluster-python
# TO_TAG:         docker tag bunop/cluster-python:latest bunop/cluster-python:0.1
#

FROM bunop/buildpack-deps-cluster:0.1

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# I can't remove python as stated in https://raw.githubusercontent.com/docker-library/python/a736fc19a99afe3d77ba108263aad53bd1b9ab65/2.7/Dockerfile
# cause yum depends on python
# RUN apt-get purge -y python.*

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

ENV PYTHON_VERSION 2.7.9

# gpg: key 18ADD4FF: public key "Benjamin Peterson <benjamin@python.org>" imported
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF

RUN set -x \
    && mkdir -p /usr/src/python \
    && curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz \
    && curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz.asc" -o python.tar.xz.asc \
    && gpg --verify python.tar.xz.asc \
    && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
    && rm python.tar.xz* \
    && cd /usr/src/python \
    && ./configure --enable-shared --enable-unicode=ucs4 \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && curl -SL 'https://bootstrap.pypa.io/get-pip.py' | python2 \
    && find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    && rm -rf /usr/src/python

# install "virtualenv", since the vast majority of users of this image will want it
RUN pip install virtualenv

# start the systemd process
# find here https://github.com/2k0ri/docker-centos7-systemd.git. This is a symbolick
# link to /lib/systemd/systemd (also /sbin/init)
CMD ["/usr/sbin/init"]
