
#file format: archive_2_IDUSERIDJOB.tar.gz.output > output_2_IDUSERIDJOB

import sys
import subprocess
from parser_log_file import update_logger_file
from job_finished import update_slave_dockers

slave = ["129.88.242.140" , None, "129.88.242.142","129.88.242.146","129.88.242.147"]



def findSlaveSource(file_name):
	print file_name, "AQUIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
	slaveNumber = file_name.strip('\n').split("/")[2].replace("slave","")
	return slaveNumber

def findGridSource(file_name):
	pieces = file_name.strip('\n').split("/")[4].split('_')
	gridNumber = pieces[1]
	return gridNumber
	
def renameOutput(file_name):
	piecesToString = file_name.strip('\n').split(".")[0].replace("archive","output")
	#piecesToString
	subprocess.call("mv "+ file_name + " " + piecesToString, shell = True)
	return piecesToString
	
def main(file_name, slave_dir):
	
	gridNumber = findGridSource(file_name)
	slaveNumber = findSlaveSource(slave_dir)
	#print "CHAMANDO UPDATE SLAVE update_slave_dockers\n"
	#print "ARG = %s\n" %("slave"+ gridNumber + "@" + slave[int(slaveNumber)]) 
	update_slave_dockers("slave"+ slaveNumber + "@" + slave[int(slaveNumber)])
	newName = renameOutput(file_name)
	update_logger_file(newName.split("/")[4], "slave"+ slaveNumber+ "@" + slave[int(slaveNumber)], "received")
	print "manager finished"
	if gridNumber == 2:
		#subprocess.Popen(["./run_job.sh", inputfile, slv_ip], shell=True) RODAR UM ENVIO PRA INTERFACE
		pass
	else:
		#subprocess.Popen(["./run_job.sh", inputfile, slv_ip], shell=True) RODAR UM ENVIO PRA INTERFACE
		pass
	#subprocess.call("rm /home/new_ordoserver/interface_ftp/"+ newName, shell=True)

if __name__ == '__main__':
	print "stqrting manager"
	main(sys.argv[1], sys.argv[2])
