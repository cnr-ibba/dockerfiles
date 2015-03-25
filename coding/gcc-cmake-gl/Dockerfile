
# VERSION 0.1
# DOCKER-VERSION  1.3.2
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A bleeding edge Ubuntu 14.04 image for compiling C++11 OpenGL projects with openssh server
# TO_BUILD:       docker build --rm -t bunop/gcc-cmake-gl:0.1 .
# TO_RUN:

# Get a andystanton/gcc-cmake-gl:1.0
FROM andystanton/gcc-cmake-gl:1.0

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# set a new workdir
WORKDIR	/root

# clean up andystanton cmake install directory
RUN rm -rf /cmake-3.0.2/ && rm -f /cmake-3.0.2.tar.gz

# install vim
RUN apt-get install -y vim

# Clean up APT cache
# RUN apt-get clean && apt-get autoclean && rm -rf /tmp/* /var/tmp/*

# Add a new user
RUN useradd -m developer 

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
