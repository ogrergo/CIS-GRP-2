#!/usr/bin/python

import time
import datetime
import fcntl
import sys


MAX_DOCKERS_PER_SLAVE = 4

# Format log file:
#date, "sent" or "received", idjob, slave@ip

log_file = "log.txt"

def update_logger_file(file_name, slave_ip, status):
	# status must be "sent" if we are sending a job to a slave, and "received" if we are receiving the result from the slave
	with open(log_file, "a+") as g:
		print "before"
		fcntl.flock(g, fcntl.LOCK_EX)
		print "in lock"

		print file_name
		try:
			if status == "sent":
				job_id = file_name.split("_")[2].split(".")[0]
		
			elif status == "received":
				job_id = file_name.split("_")[3].split(".")[0]

			else:
				raise Exception("Incorrect status.\n")				

		except:
			raise Exception("Incorrect filename format.\n")
		# getting timestamp
		ts = time.time()
		# format: day/month/year
		stamp = datetime.datetime.fromtimestamp(ts).strftime('%d/%m/%Y %H:%M:%S')


		line = "%s %s %s %s\n" %(stamp, status, job_id, slave_ip)
		print "line = %s\n" %line
		g.write(line)

		fcntl.flock(g, fcntl.LOCK_UN)