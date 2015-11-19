
#file format: archive_2_IDUSERIDJOB.tar.gz.output > output_2_IDUSERIDJOB

import sys
import subprocess

def findGridSource(file_name):
	pieces = file_name.strip('\n').split('_')
	gridNumber = pieces[1]
	return gridNumber
	
def renameOutput(file_name):
	pieces = file_name.strip('\n').split(".")[0].split("_")[1:]
	piecesToString = 'output_' + "_".join(pieces)
	subprocess.call("mv "+ file_name + " " + piecesToString, shell = True)
	
def main(file_name):
	gridNumber = findGridSource(file_name)
	renameOutput(file_name)
	return gridNumber

if __name__ == '__main__':
	print main(sys.argv[1])
