#!/bin/bash

# set up system
cp /vagrant/environment/hosts /etc/hosts

# install java
apt-get install python-software-properties
add-apt-repository --yes ppa:webupd8team/java
apt-get update
apt-get install oracle-java7-installer

# install mysql
echo mysql-server mysql-server/root_password password vagrant | debconf-set-selections
echo mysql-server mysql-server/root_password_again password vagrant | debconf-set-selections
apt-get install --yes mysql-server

# install play framework
apt-get install unzip
cd /vagrant/environment
wget http://downloads.typesafe.com/play/2.1.1/play-2.1.1.zip
unzip play-2.1.1.zip
rm -f play-2.1.1.zip

echo "export PATH=$PATH:/vagrant/environment/play-2.1.1" > ~/.bashrc
source ~/.bashrc

# start play app on port 80
cd /vagrant
play "~run 80"
