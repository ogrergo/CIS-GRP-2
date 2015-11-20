#! /bin/bash

curl -v -3 --cacert /etc/ssl/certs/interface.pem --ftp-ssl --disable-epsv --ftp-skip-pasv-ip  -T "$1" ftp://ordonnancer_output:ensiPC372@129.88.242.134
