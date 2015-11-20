#!/bin/bash
#SCHEDULER VARIABLES
ADDRESS_SCHEDULER="$USER@129.88.242.132"
REPOSITORY_SCHEDULER="~"
TIMEOUT_DELAY="10m"

#HOST VARIABLES
SLAVE_DIR="$HOME/CIS-GRP-2/slave"
JOB_DIR="$SLAVE_DIR/jobs"
JOB_ENV_DIR="$SLAVE_DIR/docker_env"
JOB_NAME="job.tar.gz"
LOG_FILE="$SLAVE_DIR/log"

#DOCKER CONTAINER VARIABLES
JOB_TAR="$JOB_ENV_DIR/job.tar.gz"
JOB_CMD="$JOB_ENV_DIR/script.sh"
JOB_INPUT="$JOB_ENV_DIR/input"
JOB_OUTPUT="$JOB_ENV_DIR/output"
CONTAINER_DIR="/home/slave_user/docker_env"
CONTAINER_INPUT="$CONTAINER_DIR/input"
CONTAINER_OUTPUT="$CONTAINER_DIR/output"
CONTAINER_CMD="$CONTAINER_DIR/script.sh"

EXIT_BY_TIMEOUT_CODE=124

echo "[INFO]- `date` - Starting slave's demon" >> $LOG_FILE

mkdir $JOB_DIR 2>/dev/null
mkdir $JOB_ENV_DIR 2>/dev/null

# send_response <abspath_to_file_to_send>
send_response() {
		#-----------------------
		# Send response
		#-----------------------
		echo "[INFO]- `date` - $file - Sending response" >> $LOG_FILE
		scp $1 $ADDRESS_SCHEDULER:$REPOSITORY_SCHEDULER
}


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
			output="$file.output"
			#-----------------------
			# Preparing environment
			#-----------------------
			echo "[INFO]- `date` - $file - File received - Preparing environment" >> $LOG_FILE
			#move the file to JOB ENV DIR
			mv $JOB_DIR/$file $JOB_TAR
			if [[ $? -ne 0 ]] ; then
				echo "[ERROR]- `date` - $file - Could not find file inside $JOB_DIR" >> $LOG_FILE
				echo "ERROR: Runtime error" >> $JOB_ENV_DIR/$output
				send_response $JOB_ENV_DIR/$output
				continue
			fi				
			#extract the archive
			echo "[INFO]- `date` - $file - Extracting job" >> $LOG_FILE
			tar -zxf $JOB_TAR -C $JOB_ENV_DIR
			if [[ $? -ne 0 ]]; then
				echo "[ERROR]- `date` - $file - Job extraction failed" >> $LOG_FILE
				echo "ERROR: Your job could not be decompressed, maybe it's not in gzip format?" >> $JOB_ENV_DIR/$output
				send_response $JOB_ENV_DIR/$output
				continue
			fi
			echo "[INFO]- `date` - $file - Editing rights" >> $LOG_FILE
			echo "" >>$JOB_INPUT 2>/dev/null
			echo "" >>$JOB_OUTPUT 2>/dev/null
			rm $JOB_ENV_DIR/$JOB_NAME
			
			#-----------------------
			# Log command
			#-----------------------
			echo "[INFO]- `date` - $file - CMD :" >> $LOG_FILE
			cat $JOB_CMD >> $LOG_FILE
			echo "[INFO]- `date` - $file - INPUT :" >> $LOG_FILE
			cat $JOB_INPUT >> $LOG_FILE
			
			#-----------------------
			# Run the job in Docker
			#-----------------------
			#rm previoux job if any
			docker rm job &>/dev/null	

			echo "[INFO]- `date` - $file - Starting job execution in Docker" >> $LOG_FILE
			docker run --rm --name job -v $JOB_ENV_DIR:$CONTAINER_DIR -it -u slave_user $USER timeout $TIMEOUT_DELAY /bin/bash -c "$CONTAINER_CMD &> $CONTAINER_OUTPUT < $CONTAINER_INPUT"
			ret=$?
			echo $ret >> $LOG_FILE
			if [[ $ret -eq $EXIT_BY_TIMEOUT_CODE ]]
			then
				echo "ERROR: your task exceeded maximum execution time." > $JOB_ENV_DIR/$output
				echo "[ERROR]- `date` - $file - Task timed out." >> $LOG_FILE
			elif [[ $ret -eq 0 ]]; then
				echo "[INFO]- `date` - $file - End of docker job execution" >> $LOG_FILE
				mv $JOB_ENV_DIR/output $JOB_ENV_DIR/"$output"
			else
				echo "[ERROR]- `date` - $file - Error in Docker's execution" >> $LOG_FILE
				echo "ERROR: Docker's execution terminated abruptly." > $JOB_ENV_DIR/$output
			fi

			#-----------------------
			# Send response
			#-----------------------
			send_response $JOB_ENV_DIR/$output

			#-----------------------
			# Clean environment
			#-----------------------
			rm $JOB_ENV_DIR/*				
			echo "[INFO]- `date` - $file - End of job and environment cleaned" >> $LOG_FILE
		fi	
	else
		sleep 2
	fi

done
