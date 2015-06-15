
# VERSION 0.1
# DOCKER-VERSION  1.6.2
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    A Matlab Compiler Runtime release R2012a (7.17)
# TO_BUILD:       docker build --rm -t bunop/matlab-mcr:7.17 .
# TO_RUN:         docker run -ti bunop/matlab-mcr:7.17 /bin/bash

# Start from buildpack-deps
FROM buildpack-deps:latest

MAINTAINER Paolo Cozzi <paolo.cozzi@tecnoparco.org>

# Install requirements
RUN apt-get update && apt-get install -y \
    unzip \
    dos2unix \
    libxmu6

# Clean up APT cache
# RUN apt-get clean && apt-get autoclean && rm -rf /tmp/* /var/tmp/*

# setting workdir
WORKDIR /root

# Download MCR pack file
ADD http://it.mathworks.com/supportfiles/MCR_Runtime/R2012a/MCR_R2012a_glnxa64_installer.zip /root/MCR_R2012a_glnxa64_installer.zip

# Unpack archive and install silent
RUN unzip MCR_R2012a_glnxa64_installer.zip -d MCR_R2012a_glnxa64 && \
    ./MCR_R2012a_glnxa64/install -mode silent -agreeToLicense yes && \
    rm -r MCR_R2012a_glnxa64*

# Set environment variables? defaults binaries would't work
# ENV LD_LIBRARY_PATH "/usr/local/MATLAB/MATLAB_Compiler_Runtime/v717/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v717/bin/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v717/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v717/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v717/sys/java/jre/glnxa64/jre/lib/amd64/server:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v717/sys/java/jre/glnxa64/jre/lib/amd64:$LD_LIBRARY_PATH"
# ENV XAPPLRESDIR "/usr/local/MATLAB/MATLAB_Compiler_Runtime/v717/X11/app-defaults"

