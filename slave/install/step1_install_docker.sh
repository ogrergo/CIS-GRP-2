# This script allows to install docker on a clean version of ubuntu 14.04

#PART 1 : add the repository to pull docker
echo "------------------------------"
echo "    Add docker's repository   "
echo "------------------------------"
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo touch /etc/apt/sources.list.d/docker.list
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get purge lxc-docker*
echo "------------------------------"
echo "Next command should show the correct repository :"
sudo apt-cache policy docker-engine
echo "------------------------------"
echo "\n\n"

#PART 2 : install linux image
echo "------------------------------"
echo "   Installing linux image...  "
echo "------------------------------"
sudo apt-get update
sudo apt-get install linux-image-extra-$(uname -r)

#PART 3 : install Docker
echo "------------------------------"
echo "     Installing Docker...     "
echo "------------------------------"
sudo apt-get update
sudo apt-get install docker-engine
sudo service docker start
echo "------------------------------"
echo " Verifying Docker is installed correctly with HELLO WORLD"
sudo docker run hello-world

echo "=============================="
echo "==============================\n"
echo " INSTALLATION COMPLETE "
echo "Now just add docker group to your user"
echo "command : sudo usermod -aG docker <your_login>"
echo "And then, log out and log back in"
