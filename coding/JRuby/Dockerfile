FROM centos:centos7
RUN  yum install -y epel-release
RUN  yum update -y && yum install -y git unzip tar wget curl vim tmux

#versions
ENV JDK_RPM jdk-7u67-linux-x64.rpm
ENV JDK_RPM_URL http://download.oracle.com/otn-pub/java/jdk/7u67-b01/
 
#install Java7
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"  $JDK_RPM_URL/$JDK_RPM 
RUN chmod a+x $JDK_RPM
RUN rpm -Uvh $JDK_RPM
RUN rm $JDK_RPM

# Install JRuby
ENV JRUBY_VERSION 1.7.16.1
RUN mkdir /opt/jruby \
			  && curl http://jruby.org.s3.amazonaws.com/downloads/${JRUBY_VERSION}/jruby-bin-${JRUBY_VERSION}.tar.gz \
				  | tar -zxC /opt/jruby --strip-components=1 \
					  && update-alternatives --install /usr/local/bin/ruby ruby /opt/jruby/bin/jruby 1
						ENV PATH /opt/jruby/bin:$PATH

						RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc

						RUN gem install bundler

# Customise VIM and environment

RUN curl -sSL https://raw.githubusercontent.com/fstrozzi/dotvim/master/install.sh | bash
RUN git config --global user.name "Francesco Strozzi"
RUN git config --global user.email francesco.strozzi@gmail.com
RUN echo "PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '" >> /root/.bashrc
RUN sed -i 's/# alias/alias/g' /root/.bashrc

# Setting the entrypoint
RUN gem install pry
CMD ["pry"]

