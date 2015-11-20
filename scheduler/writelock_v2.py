import time
import datetime
import fcntl
import fileinput
import pickle
import sys
import subprocess
import random
from parser_log_file import update_logger_file


MAX_DOCKERS_PER_SLAVE = 4
# CHECK IF THE NUMBER OF DOCKERS USED IN A SLAVE IS LOWER THAN THE MAX OF DOCKERS AVAILABLE PER SLAVE. IF IT IS, ADD +1 IN THE NUMBER OF DOCKS USED BY THAT SLAVE AND UPDATE THE FILE

slave_file = "slaves.txt"
log_file = "log.txt"
GRIDS = [1,3,4] # IPS

def update_slave_dockers():
	with open(slave_file, "a+") as g:
		#print "before"
		fcntl.flock(g, fcntl.LOCK_EX)
		#print "in lock"
		#g.write(new_entry)
		#k = g.readlines()
		#print k
		found_a_slave = False
		lines = g.readlines()
		print lines
		for line, line_index in zip (lines, range(0, len(lines))):
			slave_info = line.split(" ")
			slave_ip = slave_info[0]
			used_dockers = int(slave_info[1].split("\n")[0])
			print "Number of dockers used in %s: %d\n" %(slave_ip, used_dockers)
			print line

			if used_dockers < MAX_DOCKERS_PER_SLAVE:
				found_a_slave = True # there is an available slave

				#print "Inside the if"
				new_line = "%s %d\n" %(slave_ip, used_dockers+1)

				lines[line_index] = new_line

				# Overwrites the file, so we do not have to create a new one
				with open(slave_file, "w+") as f:
					f.writelines(["%s" %item  for item in lines])

				f.close()
				#print "endif"

				break

		time.sleep(1)
		fcntl.flock(g, fcntl.LOCK_UN)
		g.close()
		#print "unlocked"
		if found_a_slave is True:
			return slave_ip

		# we must do something if there is not an available slave to run the task
		else:
			#pass
			return None
			#raise Exception("No available servers to execute the task at the moment.\n")
	

def main():
	if len(sys.argv) >= 2:
		# format expected for the input file:
		# archive_2_idJob.extension

		inputfile = sys.argv[1]
		print "file = %s" %inputfile
		slv_ip = update_slave_dockers()
		#new_inputfile_name = "%s_%s" %(slv_ip, inputfile)
		if slv_ip == None:
			chosedGrid = random.choice(GRIDS)

			# WE NEED THE GRID IP
			# WE NEED TO SEND IT

			update_logger_file(inputfile, "GRID "+ str(chosedGrid), "sent")
			#subprocess.call("rm /home/new_ordoserver/received_jobs/"+ inputfile)
			#raise Exception("We need that grid ip =((((((.\n")
			# REMOVE


		else:
			update_logger_file(inputfile, slv_ip, "sent")
			#filename of the file sent to the slave is as follows: slaveID@IPSlave_FileName
			subprocess.call("./run_job.sh /home/new_ordoserver/received_jobs/"+inputfile+ " "+ slv_ip, shell=True)
			subprocess.call("rm /home/new_ordoserver/received_jobs/"+ inputfile, shell=True)


	else:
		print "You should inform the file name. Run: python writelock_2.py file_name\n"

if __name__ == "__main__":
	main()
