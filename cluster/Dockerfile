FROM centos:6
RUN yum -y update
RUN yum -y install ypbind openssh-server authconfig
RUN authconfig --enablenis --nisdomain=BIOINFORMATICS --nisserver=login.bioinformatics.tecnoparco.org --update
RUN echo -e "192.168.13.41\tlogin.bioinformatics.tecnoparco.org" >> /etc/hosts

