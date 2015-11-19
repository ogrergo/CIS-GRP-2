#!/bin/bash
JOB_DIR="/home/slave_user/docker_env"
JOB_TAR="$JOB_DIR/job.tar.gz"
JOB_CMD="$JOB_DIR/job_cmd.sh"
JOB_INPUT="$JOB_DIR/input"
JOB_OUTPUT="$JOB_DIR/output"

#extract the archive
tar -zxvf $JOB_TAR -C $JOB_DIR

#add execution rights to the job
chmod u+x $JOB_CMD

#run the sh file with redirections
>>$JOB_INPUT # creates input if doesn't exist
$JOB_CMD &> $JOB_OUTPUT < $JOB_INPUT

#clean the directory, leaving only the output
rm $JOB_CMD $JOB_INPUT  $JOB_TAR
#leave the countainer
exit
