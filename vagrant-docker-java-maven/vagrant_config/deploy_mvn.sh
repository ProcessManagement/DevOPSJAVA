#!/bin/bash
#===============================================================================
#
#          FILE:  deploy_mvn.sh
# 
#         USAGE:  ./deploy_mvn.sh 
# 
#   DESCRIPTION:  Deploys the software build system Maven and its prerequisite, Java
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

echo "Installing wget..."
yum install -y wget

echo "Downloading Java..."
wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.tar.gz -O - >> /tmp/jdk-8u25-linux-x64.tar.gz

echo "Installing Java..."
tar xzvf /tmp/jdk-8u25-linux-x64.tar.gz
mv jdk1.8.0_25 /opt

echo "Downloading Maven..."
wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz -O - >> /tmp/apache-maven-3.2.5-bin.tar.gz

echo "Installing Maven..."
tar xzvf /tmp/apache-maven-3.2.5-bin.tar.gz
mv apache-maven-3.2.5 /opt
cp -p /vagrant/vagrant_config/settings.xml /opt/apache-maven-3.2.5/conf/settings.xml
chown root:wheel /opt/apache-maven-3.2.5/conf/settings.xml

# Set environmental variables
echo 'export JAVA_HOME=/opt/jdk1.8.0_25' >> /home/vagrant/.bashrc
echo 'export M2_HOME=/opt/apache-maven-3.2.5' >> /home/vagrant/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$M2_HOME/bin:bin:$PATH' >> /home/vagrant/.bashrc
echo 'cd /vagrant' >> /home/vagrant/.bashrc
