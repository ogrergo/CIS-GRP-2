#!/bin/bash
#run_command='tar -xzf "$1" ; chmod +x script.sh ; ./script.sh > output ; exit'
#echo $run_command
echo $1
echo $2
username=`tr "@" " " <<< $2 | awk '{ print $1; }'`
while [[ `lsof 2>/dev/null | grep $1` ]] ; do sleep 2; done
scp $1 $2:/home/$username/CIS-GRP-2/slave/jobs 2>&1 1>/dev/null

