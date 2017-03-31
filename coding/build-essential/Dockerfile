
# VERSION 0.1
# DOCKER-VERSION  1.9.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp>
# DESCRIPTION:    A Ubuntu 16.04 image for compiling code
# TO_BUILD:       docker build --rm -t ptp/build-essential .
# TO_RUN:         docker run -ti ptp/build-essential /bin/bash
# TO_TAG:         docker tag ptp/build-essential:latest ptp/build-essential:0.1

# Get a andystanton/gcc-cmake-gl:1.0
FROM ubuntu:16.04

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

# set a new workdir
WORKDIR	/root

# install vim and bash completion
RUN apt-get update && \
  apt-get install -y vim \
    git-core \
    bash-completion \
    unzip \
    sudo \
    build-essential && \
  apt-get clean && \
  apt-get autoclean && \
  rm -rf /var/lib/apt/lists/*

# Add a new user and add it to sudo
RUN useradd -m developer && \
  echo "developer:docker" | chpasswd && \
  adduser developer sudo

# Setting useful environment variables
WORKDIR /home/developer

# overwrite .bashrc
COPY bashrc /home/developer/.bashrc
COPY vimrc /home/developer/.vimrc
copy gitconfig /home/developer/.gitconfig
RUN chown developer: .bashrc .vimrc .gitconfig

# Set home directory as VOLUME
VOLUME /home/developer

# Setting the user
USER developer

# default command to reattach istance
CMD ["/bin/bash"]
