#! /bin/bash

adduser auth

#on creer le fichier de log
touch /var/log/output_ftp_transfert.log
chown auth:auth /var/log/output_ftp_transfert.log

#
apt-get install incron
echo "auth" >> /etc/incron.allow

#dossier tmp qui permet de recevoir les nouveaux fichiers
mkdir /home/auth/tmp
chown auth:auth /home/auth/tmp

touch /etc/user_map

#install vsftpd

adduser --disabled-login --gecos "" ftpserver
echo "ftpserver" | passwd ftpserver --stdin

echo "ftpserver" > /etc/vsftpd.userlist


