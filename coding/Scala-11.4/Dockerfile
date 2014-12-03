FROM centos:centos7
RUN  yum install -y epel-release
RUN  yum update -y && yum install -y git zsh unzip tar wget curl vim tmux

#versions
ENV JDK_RPM jdk-7u67-linux-x64.rpm
ENV JDK_RPM_URL http://download.oracle.com/otn-pub/java/jdk/7u67-b01/
ENV SCALA_TAR_URL http://www.scala-lang.org/files/archive
ENV SCALA_VERSION 2.11.4
ENV SBT_VERSION 0.13.7
 
#install java
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"  $JDK_RPM_URL/$JDK_RPM 
RUN chmod a+x $JDK_RPM
RUN rpm -Uvh $JDK_RPM
RUN rm $JDK_RPM

#install scala
RUN wget $SCALA_TAR_URL/scala-$SCALA_VERSION.tgz
RUN tar xvf scala-$SCALA_VERSION.tgz
RUN mv scala-$SCALA_VERSION /usr/lib
RUN rm scala-$SCALA_VERSION.tgz
RUN ln -s /usr/lib/scala-$SCALA_VERSION /usr/lib/scala

ENV PATH $PATH:/usr/lib/scala/bin
 
# install sbt
RUN wget -O /usr/local/bin/sbt-launch.jar http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/$SBT_VERSION/sbt-launch.jar
RUN wget --no-check-certificate https://raw.githubusercontent.com/ecompositor/centos-scala/master/scripts/sbt.sh -O /usr/local/bin/sbt
RUN chmod 755 /usr/local/bin/sbt
# install custom vim themes and plugins
RUN curl -sSL https://raw.githubusercontent.com/fstrozzi/dotvim/master/install.sh | bash
RUN git config --global user.name "Francesco Strozzi"
RUN git config --global user.email francesco.strozzi@gmail.com
# set tmux aliases and configuration
RUN curl https://raw.githubusercontent.com/fstrozzi/dockerfiles/master/coding/tmux.conf > /root/.tmux.conf
# zsh
RUN curl -L http://install.ohmyz.sh | sh
RUN curl https://raw.githubusercontent.com/fstrozzi/dockerfiles/master/coding/zshrc > /root/.zshrc
CMD ["scala"]
