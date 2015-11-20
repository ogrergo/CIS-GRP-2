#!/bin/bash
file_name=$1
dir=$2
sudo mv $dir/$file_name /home/new_ordoserver/interface_out/$file_name
python /home/new_ordoserver/Documents/manager_output_file.py /home/new_ordoserver/interface_out/$file_name $dir
