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

while true
do

	#test if a file exists in JOB_DIR
	if test "$(ls -A "$JOB_DIR")"; then
		#get first job
		file=`ls "$JOB_DIR" | head -1`;		
		
		#make sure file is not being written
		#if ! [[ `lsof | grep $file` ]]
		#then
			#move the file to JOB ENV DIR
			mv "$JOB_DIR"/"$file" "$JOB_ENV_DIR"/"$JOB_NAME"
			
			#-----------------------
			# Run the job in docker
			#-----------------------
			
			#rm previoux job if any
			docker rm job &>/dev/null
			
			docker run --name job -v $JOB_ENV_DIR:$CONTAINER_DIR -it -u slave_user $USER /bin/bash $CONTAINER_DIR/run.sh
			
			#when docker container is closed, send response	
			output="$file.output"
			mv ~/docker_env/output ~/docker_env/"$output"
			scp ~/docker_env/$output $ADDRESS_SCHEDULER:$REPOSITORY_SCHEDULER
			
			#clean
			rm ~/docker_env/"$output"
		#fi	
	else
		sleep 2
	fi

done
