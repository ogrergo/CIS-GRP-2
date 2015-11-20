#!/bin/bash
filename=$1

type=$(tr "_" " " <<< $1 | awk '{ print $1; }')

if [[ $type = "archive" ]]; then
	# Move to archives folder
	sudo mv $1 /home/interface_ftp
elif [[ $type = "output" ]]; then
	# Send the output back
	sudo mv $1 /home/new_ordoserver/interface_out
else
	# Out of format
	rm $1
fi


