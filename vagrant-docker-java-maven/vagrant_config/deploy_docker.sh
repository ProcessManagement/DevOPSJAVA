#!/bin/bash
#===============================================================================
#
#          FILE:  deploy_docker.sh
# 
#         USAGE:  ./deploy_docker.sh 
# 
#   DESCRIPTION:  Deploy Docker onto CentOS 6.5 Vagrant VM
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Matt Coffey (), 
#       COMPANY:  
#       VERSION:  1.0
#      REVISION:  ---
#===============================================================================

echo "Installing Docker and prerequisites"
yum update -y device-mapper-libs
yum install -y docker-io

echo "Configuring Docker..." 
echo 'other_args="-H tcp://0.0.0.0:4243"' >> /etc/sysconfig/docker 
service docker restart 
# Setup vagrant user for docker 
echo 'export DOCKER_HOST=tcp://0.0.0.0:4243' >> /home/vagrant/.bashrc 
echo 'alias docker="sudo docker -H $DOCKER_HOST"' >> /home/vagrant/.bashrc 
 
# Setup /etc/hosts (not sure why we need vagrant-centos65.vagrantup.com) 
echo '127.0.0.1    vagrant-centos65.vagrantup.com dockerhost' >> /etc/hosts
