#!/usr/bin/python

import time
import fcntl
import sys
from parser_log_file import update_logger_file


MAX_DOCKERS_PER_SLAVE = 4
# CHECK IF THE NUMBER OF DOCKERS USED IN A SLAVE IS LOWER THAN THE MAX OF DOCKERS AVAILABLE PER SLAVE. IF IT IS, ADD +1 IN THE NUMBER OF DOCKS USED BY THAT SLAVE AND UPDATE THE FILE

slave_file = "slaves.txt"

def update_slave_dockers(slv_ip):
	with open(slave_file, "a+") as g:
		print "before"
		fcntl.flock(g, fcntl.LOCK_EX)
		print "in lock"
		lines = g.readlines()
		print lines
		for line, line_index in zip (lines, range(0, len(lines))):
			slave_info = line.split(" ")
			slave_ip = slave_info[0]

			print "given ip: %s, slave ip: %s\n" %(slv_ip, slave_ip)
			if slv_ip == slave_ip:

				used_dockers = int(slave_info[1].split("\n")[0])
				print "Number of dockers used in %s: %d\n" %(slave_ip, used_dockers)
				print line

				if used_dockers == 0:
					raise Exception("%s is not currently executing any tasks.\n" %slv_ip)

				elif used_dockers > 0:
					print "Inside the if"
					new_line = "%s %d\n" %(slave_ip, used_dockers-1)

					lines[line_index] = new_line

					# Overwrites the file, so we do not have to create a new one
					with open(slave_file, "w+") as f:
						f.writelines(["%s" %item  for item in lines])

					f.close()
					print "endif"

					break

		time.sleep(1)
		fcntl.flock(g, fcntl.LOCK_UN)

		print "unlocked"



def main():
	if len(sys.argv) >= 3:
		slv_ip = sys.argv[1]

		# format expected for the output file:
		# output_archive_2_idJob.extension
		output_filename = sys.argv[2]
		update_slave_dockers(slv_ip)

		update_logger_file(output_filename, slv_ip, "received")

	else:
		print "You must enter an IP address. To run the script, use: job_finished.py slave_ip output_filename\n"

if __name__ == "__main__":
	main()
