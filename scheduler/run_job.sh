#!/bin/bash
#run_command='tar -xzf "$1" ; chmod +x script.sh ; ./script.sh > output ; exit'
#echo $run_command

function run {
	scp -P 22 "$1" $2:/home/slv 2>&1 1>/dev/null
}

slave_usrip=$2
run "$1" $slave_ip
