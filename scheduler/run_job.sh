#!/bin/bash
#run_command='tar -xzf "$1" ; chmod +x script.sh ; ./script.sh > output ; exit'
#echo $run_command

function run {
	scp -P 2223 "$1" slv@$slave_ip:/home/slv 2>&1 1>/dev/null
	ssh slv@$slave_ip -p 2223 2>&1 1>/dev/null <<+
	tar -xzf "$1" ; chmod +x script.sh ; ./script.sh > output ; exit
+
	scp -P 2223 slv@$slave_ip:/home/slv/output . 2>&1 1>/dev/null
	ssh slv@$slave_ip -p 2223 2>&1 1>/dev/null <<COMM
	rm -rf * ; exit
COMM
}

slave_ip=$2
run "$1"
