
#
# VERSION 0.1
# DOCKER-VERSION  1.3.2
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    An image like buildpack-deps/jessie/scm/Dockerfile
# TO_BUILD:       docker build --rm -t bunop/buildpack-deps-cluster-scm .
# TO_RUN:         docker run -d -P --privileged --cap-add=ALL -v /sys/fs/cgroup:/sys/fs/cgroup:ro bunop/buildpack-deps-cluster-scm
# TO_TAG:         docker tag bunop/buildpack-deps-cluster-scm:latest bunop/buildpack-deps-cluster-scm:0.1
#

FROM bunop/buildpack-deps-cluster-curl:0.1

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

RUN yum install -y \
    bzr \
    git \
    mercurial \
    openssh-client \
    subversion

# Free spaces
RUN yum clean all
