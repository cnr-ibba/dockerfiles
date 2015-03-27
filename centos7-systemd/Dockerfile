
FROM 2k0ri/centos7-systemd

# Install and enable SSHD service
RUN yum -y install openssh-server; systemctl enable sshd.service

RUN mkdir /var/run/sshd
RUN echo 'root:systemd' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Free spaces
RUN yum clean all

# Ports to expose
EXPOSE 22

# find here https://github.com/2k0ri/docker-centos7-systemd.git
CMD ["/sbin/init", "3"]