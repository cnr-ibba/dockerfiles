
# VERSION 0.2
# DOCKER-VERSION  1.3.2
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A Neo4j instance database
# TO_BUILD:       docker build --rm -t paolo/neo4j:wheezy .
# TO_RUN:

# Get a debian:wheezy image
FROM debian:wheezy

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# Get local mirrors
COPY garr_sources.list /etc/apt/sources.list

# A set of preparatory instructions
RUN apt-get update && apt-get install -y \
	apt-utils \
	wget \
	openssh-server \
	supervisor

# those instructions are debian specific. Import neo4j signing key
RUN wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add -

# Create an Apt sources.list file
RUN echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list

# Find out about the files in our repository
RUN apt-get update -y

# Install Neo4j, community edition
RUN apt-get install -y neo4j 

# Clean up APT when done.
RUN apt-get clean && apt-get autoclean && rm -rf /tmp/* /var/tmp/*

# Instructions for ssh found here: https://docs.docker.com/examples/running_ssh_service/
RUN mkdir /var/run/sshd
RUN echo 'root:neo4j' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Using the sshd daemon to spawn shells makes it complicated to pass environment variables
# to the user's shell via the normal Docker mechanisms, as sshd scrubs the environment before it starts the shell.
# If you're setting values in the Dockerfile using ENV, you'll need to push them to a shell
# initialization file like the /etc/profile example in the Dockerfile above.

# If you need to passdocker run -e ENV=value values, you will need to write a short
# script to do the same before you start sshd -D and then replace the CMD with that script.
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Copy supervisord configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy neo4j configuration file
COPY neo4j-server.properties /etc/neo4j/neo4j-server.properties

# Create a VOLUME for data directory
VOLUME /var/lib/neo4j/data

# Ports to expose outside
EXPOSE 22 7473 7474

# Running all my processes
CMD ["/usr/bin/supervisord"]
