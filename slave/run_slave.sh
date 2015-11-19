#!/bin/bash
#SCHEDULER VARIABLES
ADDRESS_SCHEDULER="$USER@129.88.242.132"
REPOSITORY_SCHEDULER="~"

#HOST VARIABLES
SLAVE_DIR="$HOME/CIS-GRP-2/slave"
JOB_DIR="$SLAVE_DIR/jobs"
JOB_ENV_DIR="$SLAVE_DIR/docker_env"
JOB_NAME="job.tar.gz"
LOG_FILE="$SLAVE_DIR/log"

#DOCKER CONTAINER VARIABLES
CONTAINER_DIR="/home/slave_user/docker_env"

mkdir $JOB_DIR 2>/dev/null
echo "[INFO]- `date` - Starting slave's demon" >> $LOG_FILE
while true
do

	#test if a file exists in JOB_DIR
	if test "$(ls "$JOB_DIR")"; then
		#get first job
		file=`ls "$JOB_DIR" | head -1`;			
		echo "[INFO]- `date` - $file - Reveiving job file..." >> $LOG_FILE
		#make sure file is not being written
		if ! [[ `lsof 2>/dev/null | grep $JOB_DIR/$file` ]]
		then
			
			echo "[INFO]- `date` - $file - File received - Preparing environment" >> $LOG_FILE
			
			#move the file to JOB ENV DIR
			mv "$JOB_DIR"/"$file" "$JOB_ENV_DIR"/"$JOB_NAME"
			
			#-----------------------
			# Run the job in docker
			#-----------------------
			
			#rm previoux job if any
			docker rm job &>/dev/null	
			
			echo "[INFO]- `date` - $file - Running docker environment" >> $LOG_FILE
			docker run --name job -v $JOB_ENV_DIR:$CONTAINER_DIR -it -u slave_user $USER /bin/bash $CONTAINER_DIR/run.sh
			cat $JOB_ENV_DIR/log >> $LOG_FILE
			echo "[INFO]- `date` - $file - End of docker execution - Sending response" >> $LOG_FILE
			
			#when docker container is closed, send response	and clean
			output="$file.output"
			mv $JOB_ENV_DIR/output $JOB_ENV_DIR/"$output"
			scp $JOB_ENV_DIR/$output $ADDRESS_SCHEDULER:$REPOSITORY_SCHEDULER
			rm $JOB_ENV_DIR/"$output"
				
			echo "[INFO]- `date` - $file - End of job" >> $LOG_FILE
		fi	
	else
		sleep 2
	fi

done
