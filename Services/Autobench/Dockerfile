
#
# VERSION 0.2
# DOCKER-VERSION  1.7.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    An image with Autobench (a simple Perl script for automating the process of benchmarking a web server)
# TO_BUILD:       docker build --rm -t ptp/autobench .
# TO_RUN:         docker run -ti ptp/autobench:latest /bin/bash
# TO_TAG:         docker tag ptp/autobench:latest ptp/autobench:0.2
#

# Starting from a debian jessie
FROM debian:jessie

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

# A set of preparatory instructions
RUN apt-get update && apt-get install -y \
	git \
	build-essential \
	httperf \
	man \
	gawk \
	gnuplot

# getting autobench: http://www.xenoclast.org/autobench/
RUN git clone https://github.com/menavaur/Autobench.git /root/Autobench

# setting work directory
WORKDIR /root/Autobench

# compiling code
RUN make && make install

# Clean packages and histories
RUN apt-get clean && rm -rf /var/lib/apt/lists/

# setting a new work directory
WORKDIR /root

# default command to reattach istance
CMD ["/bin/bash"]
