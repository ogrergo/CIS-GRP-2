Scheduler configuration:

	System folders:
There's a list of folders that must be created to the scheduler work correctly:
	/jobs - for files sent by other grids
	/home/interface_ftp - for communication with interface
	/home/slaveX - one user folder for each slave
	/home/sched_usr/interface_out/ - for interface communication
	
	Incron configuration:
The incrontable of the scheduler must run as root user. Its configuration table is in "incron_table.txt".

	System files:
	/home/sched_usr/Documents/slaves.txt - this file contains the user name and ip of each slave machine followed by '0' in the format: "username@ip 0"
	/home/usr/Documents/log.txt - this file contains the scheduler's log
	
	Scripts:
	manager_output_file.py: the variable slaves must have all the slaves' ips
				GRID_USERS must have the user name, ip address and local folder of the scheduler server in the third party grids
	writelocker_v2.py: GRID_USERS must be changed the same way as manager_output_file.py
