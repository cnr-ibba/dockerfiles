#/bin/bash

if [ "$#" = 0 ]; then
  echo "Error: You must provide a user name"
  exit
fi

USER=$1

mkdir -p /home/$USER
cp /etc/skel/.* /home/$USER/
echo "alias passwd='yppasswd'" >> /home/$USER/.bashrc
chown -R $USER:$USER /home/$USER
chmod -R 700 /home/$USER

echo "AllowUsers $USER" >> /etc/ssh/sshd_config
service sshd restart