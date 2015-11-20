#! /bin/bash

#$1 -> fichier uploaded
LOG=/var/log/output_ftp_transfert.log

main () {
	FPATH="/home/auth/tmp/$(basename $1)";
	mv "$1" "$FPATH";


#Extraction du uid et du numero de job
	FILENAME=$(basename $FPATH);
	USER_UID=$(echo -n "$FILENAME" | perl -ne 'm/^output_2_(\d+)\d{4}$/; print "$1"');
	JOB_NUM=$(echo -n "$FILENAME" | perl -ne 'm/^output_2_\d+(\d{4})$/; print "$1"');

	if [ -z $USER_UID -o -z $JOB_NUM ] 
	then
		echo "[$(date)] $1 is not in correct format" >> $LOG
		exit -1
	fi;

#determination de l'user avec le uid
	USER_NAME=$(cat /etc/user_map | perl -sne 'chomp; if( m/^([^:]+):$id$/) {print "$1";}' -- -id="$USER_UID");
	
	if [ -z $USER_NAME ]
	then
		echo "[$(date)] $USER_UID do not refer to an existing user in $1" >> $LOG
		exit -1
	fi;

#renomage et copie
	NPATH="/home/$USER_NAME/output$JOB_NUM";
	mv "$FPATH" "$NPATH";
	chown $USER_NAME:$USER_NAME "$NPATH";
		
	echo "[$(date)] $1 handled, user:$USER_NAME, job_number:$JOB_NUM" >> $LOG
	
};

if [ -e $1 ]
then
	main $1;
else
	echo "[$(date)] $1 not exist" >> $LOG;
fi;
