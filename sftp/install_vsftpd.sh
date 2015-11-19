#! /bin/bash

#$1 -> nom de l'utilisateur

apt-get install vsftpd
mkdir /etc/vsftpd
cat > /etc/vsftpd.conf << EOF
local_enable=YES
write_enable=YES

#droit
chroot_local_user=YES
local_umask=022
chown_uploads=YES
chown_username=$1

#log et utils
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd


#interdiction les utilisateurs anonymes
anonymous_enable=NO
anon_upload_enable=NO
anon_mkdir_write_enable=NO
anon_other_write_enable=NO
anon_world_readable_only=NO

#port d'écoute
connect_from_port_20=YES
listen_port=22

# Options for SSL
ssl_enable=YES
allow_anon_ssl=NO
force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_tlsv1=NO
ssl_sslv2=NO
ssl_sslv3=YES
#on oblige le client a etre authentik
validate_cert=YES 

#certificats
rsa_cert_file=/etc/ssl/private/vsftpd.cert.pem
rsa_private_key_file=/etc/ssl/private/vsftpd.key.pem

#user list
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO

EOF
