FROM williamyeh/scala:2.10.4
RUN apt-get update && apt-get -y install vim vim-nox git curl python
RUN curl -sSL https://raw.githubusercontent.com/fstrozzi/dotvim/master/install.sh | bash
RUN git config --global user.name "Francesco Strozzi"
RUN git config --global user.email francesco.strozzi@gmail.com
RUN echo "PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '" >> /root/.bashrc
RUN sed -i 's/# alias/alias/g' /root/.bashrc

