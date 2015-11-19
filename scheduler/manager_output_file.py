
#file format: archive_2_IDUSERIDJOB.tar.gz.output > output_2_IDUSERIDJOB

import sys
import subprocess
from parser_log_file import update_logger_file

def findGridSource(file_name):
	pieces = file_name.strip('\n').split('_')
	gridNumber = pieces[1]
	return gridNumber
	
def renameOutput(file_name):
	pieces = file_name.strip('\n').split(".")[0].split("_")[1:]
	piecesToString = 'output_' + "_".join(pieces)
	subprocess.call("mv "+ file_name + " " + piecesToString, shell = True)
	return piecesToString
	
def main(file_name):
	gridNumber = findGridSource(file_name)
	newName = renameOutput(file_name)
	update_logger_file(newName, gridNumber, "received")
	if gridNumber == 2:
		#subprocess.Popen(["./run_job.sh", inputfile, slv_ip], shell=True) RODAR UM ENVIO PRA INTERFACE
		pass
	else:
		#subprocess.Popen(["./run_job.sh", inputfile, slv_ip], shell=True) RODAR UM ENVIO PRA INTERFACE
		pass
	#subprocess.call("rm /home/new_ordoserver/interface_ftp/"+ newName, shell=True)

if __name__ == '__main__':
	print main(sys.argv[1])
