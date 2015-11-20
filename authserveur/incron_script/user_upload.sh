#! /bin/bash

upload_to_ordo () {
	curl -v -3 \
         --cacert /etc/ssl/certs/ordonnancer.pem \
        --disable-epsv --ftp-skip-pasv-ip \
        -T "$1" \
        ftp://interface_ftp:interface_ftp@129.88.242.132 \
        --ftp-ssl 2>> /home/authserveur/log_ftp.log
};


get_archive_code () {
	USER="$1"
	COUNTER="/home/authserveur/user_counter/$1"
	ID=$(cat /etc/user_map | perl -sne 'chomp; if( m/^$user:(\d+)$/) {print "$1";}' -- -user="$USER");
	#test id null
	
	COUNT=$(cat "$COUNTER")
	echo "$(($COUNT + 1))" > "$COUNTER"
	
	printf "%d%04d\n" $ID $COUNT
};

move_and_rename () {
	ARCHIVE_CODE=$(get_archive_code $2)
	LOC=/home/authserveur/tmp/archive_2_"$ARCHIVE_CODE".tar.gz
	cp "$1" "$LOC"
	upload_to_ordo "$LOC"
	rm "$LOC"

	echo "Send archive $ARCHIVE_CODE to ordonnancer" >> /home/authserveur/log_user_send.log
};

find_user () {
	echo $(echo "$1" | perl -ne 'if( m#^/home/([^/]+)/.*$#) {print "$1";}')
}
move_and_rename $1 $(find_user $1)
