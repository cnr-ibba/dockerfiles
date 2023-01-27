#
# VERSION 0.1
# DOCKER-VERSION  20.10.23
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    Jupyterlab with tensorflow and GPU support
# TO_BUILD:       docker build --rm -t bunop/tensorflow-jupyterlab:latest .
# TO_RUN:         docker run --gpus all -it --rm -u $(id -u):$(id -g) -v $(realpath $PWD):/tf/notebooks -p 8888:8888 bunop/tensorflow-jupyterlab:latest
# TO_TAG:         docker tag bunop/tensorflow-jupyterlab:latest bunop/tensorflow-jupyterlab:0.1
#

# base image
FROM tensorflow/tensorflow:2.11.0-gpu-jupyter

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

# Upgrade pip
RUN pip install -U pip

# Install requirements
COPY requirements.txt /root/
RUN pip install -r /root/requirements.txt

# Create jupyter configuration dir
RUN mkdir /.jupyter && chmod 7777 /.jupyter

CMD ["bash", "-c", "source /etc/bash.bashrc && jupyter lab --notebook-dir=/tf --ip 0.0.0.0 --no-browser --allow-root"]
