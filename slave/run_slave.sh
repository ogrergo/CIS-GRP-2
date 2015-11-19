#!/bin/bash
#SCHEDULER VARIABLES
ADDRESS_SCHEDULER="$USER@129.88.242.132"
REPOSITORY_SCHEDULER="~"

#HOST VARIABLES
SLAVE_DIR="$HOME/CIS-GRP-2/slave"
JOB_DIR="$SLAVE_DIR/jobs"
JOB_ENV_DIR="$SLAVE_DIR/docker_env"
JOB_NAME="job.tar.gz"

#DOCKER CONTAINER VARIABLES
CONTAINER_DIR="/home/slave_user/docker_env"

EXIT_BY_TIMEOUT_CODE=124

mkdir $JOB_DIR 2>/dev/null

while true
do

	#test if a file exists in JOB_DIR
	if test "$(ls "$JOB_DIR")"; then
		#get first job
		file=`ls "$JOB_DIR" | head -1`;		
		
		#make sure file is not being written
		if ! [[ `lsof 2>/dev/null | grep $JOB_DIR/$file` ]]
		then
			#move the file to JOB ENV DIR
			mv "$JOB_DIR"/"$file" "$JOB_ENV_DIR"/"$JOB_NAME"
			
			#-----------------------
			# Run the job in docker
			#-----------------------
			
			#rm previoux job if any
			docker rm job &>/dev/null
			output="$file.output"
			timeout 10m docker run --name job -v $JOB_ENV_DIR:$CONTAINER_DIR -it -u slave_user $USER /bin/bash $CONTAINER_DIR/run.sh
			# this if MUST be run after the timeout command
			# or timeout's return code must be saved!
			if [[ $? -eq $EXIT_BY_TIMEOUT_CODE ]]
			then
				echo "ERROR: your task exceeded maximum execution time." > $JOB_ENV_DIR/"$output"
				echo "[ERROR]- `date` - $file - Task timed out." >> log
			else
				mv $JOB_ENV_DIR/output $JOB_ENV_DIR/"$output"
			fi
			#when docker container is closed, send response	
			scp $JOB_ENV_DIR/$output $ADDRESS_SCHEDULER:$REPOSITORY_SCHEDULER
			
			#clean
			rm $JOB_ENV_DIR/"$output"
		fi	
	else
		sleep 2
	fi

done

#TODO: timeout, logs
