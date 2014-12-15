FROM centos:centos7
RUN yum install -y epel-release
RUN yum update -y && yum install -y openssl098e git unzip tar wget curl vim tmux zsh R-core R-devel gcc gcc-c++ gfortran libxml2-devel libcurl-devel the_silver_searcher
RUN echo 'root:rserver' | chpasswd
RUN R --vanilla -e "source(\"http://bioconductor.org/biocLite.R\"); biocLite()"
RUN yum -y localinstall http://download2.rstudio.org/rstudio-server-0.98.1091-x86_64.rpm
RUN mkdir -p /var/lock/subsys
RUN adduser rserver && echo 'rserver:rserver' | chpasswd
RUN yum install -y python-pip && pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor
ADD supervisord /etc/supervisord.conf

EXPOSE 8787
CMD ["supervisord", "-n"]

