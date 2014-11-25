FROM centos:centos7
RUN  yum install -y epel-release
RUN  yum update -y && yum install -y git libffi-devel autoconf gcc make unzip tar wget curl vim tmux bison openssl-devel readline-devel

# Installing Ruby

ENV RUBY_MAJOR 2.1
ENV RUBY_VERSION 2.1.5

RUN mkdir -p /usr/src/ruby
RUN curl http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz \
		| tar -xzC /usr/src/ruby --strip-components=1 \
		&& cd /usr/src/ruby \
		&& autoconf \
		&& ./configure --disable-install-doc \
		&& make -j"$(nproc)" \
		&& make install \
		&& rm -fr /usr/src/ruby

RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH
RUN gem install bundler \
	&& bundle config --global path "$GEM_HOME" \
	&& bundle config --global bin "$GEM_HOME/bin"

RUN yum -y remove gcc bison

# Customise VIM and environment
RUN curl -sSL https://raw.githubusercontent.com/fstrozzi/dotvim/master/install.sh | bash
RUN git config --global user.name "Francesco Strozzi"
RUN git config --global user.email francesco.strozzi@gmail.com
RUN echo "PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '" >> /root/.bashrc
RUN sed -i 's/# alias/alias/g' /root/.bashrc
RUN echo "alias tmux='tmux -2'" >> /root/.bashrc

# Setting the entrypoint
RUN gem install pry
CMD ["pry"]
