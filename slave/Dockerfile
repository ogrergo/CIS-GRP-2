# pull base image
FROM ubuntu:trusty

# maintainer details
MAINTAINER self

# create user
RUN useradd -m -d /home/slave_user -p slave_user slave_user && chsh -s /bin/bash slave_user

# set working directory
WORKDIR /home/slave_user

# run terminal
# CMD ["/bin/bash"]

# add default file environment
#COPY /home/slave0/data/run_job.sh /home/slave_user/run_job.sh
