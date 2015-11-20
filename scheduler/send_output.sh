#!/bin/bash
file_name=$1
dir=$2
sudo mv $dir/$file_name /home/new_ordoserver/interface_ftp
python manager_output_file.py $file_name
