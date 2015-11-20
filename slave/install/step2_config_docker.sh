#Run to config CIS docker configuration

#Step 1 : stop docker service
sudo service docker stop

#Step 2 : update docker config file
echo "limit nproc 200 400
limit nofile 100 200
limit fsize 102400000 204800000" | sudo tee -a /etc/init/docker.conf

#Step 3 : restart docker service
sudo service docker start

#Step 4 : build docker custom image
docker build -t $USER $HOME/CIS-GRP-2/slave/install

