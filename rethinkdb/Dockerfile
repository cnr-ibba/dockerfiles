FROM centos:latest
MAINTAINER Francesco Strozzi
RUN yum -y upgrade
RUN yum -y install wget
RUN wget http://download.rethinkdb.com/centos/6/`uname -m`/rethinkdb.repo -O /etc/yum.repos.d/rethinkdb.repo
RUN yum -y install rethinkdb
CMD ["rethinkdb", "--bind", "all"]
EXPOSE 8080 28015 29015
