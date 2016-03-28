# *************************************
# Install Some software from apt
# *************************************
apt-get update
apt-get install -y git subversion wget
apt-get install -y docker.io
apt-get install -y openjdk-7-jdk
apt-get install -y maven
rm -rf /var/lib/apt/lists/*

# *************************************
# Install Eclipse
# *************************************
# Vagrant automatically mount local project folder to /vagrant
echo 'Installing Eclipse'
cp /vagrant/run /usr/local/bin/eclipse
chmod 755 /usr/local/bin/eclipse
cp /vagrant/eclipse-java-luna-SR2-linux-gtk-x86_64.tar.gz /tmp/eclipse.tar.gz
tar -xf /tmp/eclipse.tar.gz -C /opt
rm /tmp/eclipse.tar.gz

# *************************************
# Install Cayenne
# *************************************
[ ! -e /home/common ] && mkdir /home/common
echo 'Get Cayenne 2.0.4'
wget http://archive.apache.org/dist/cayenne/cayenne-2.0.4.tar.gz -O /home/common/cayenne-2.0.4.tar.gz -q
echo 'Installing Cayenne'
tar -xf /home/common/cayenne-2.0.4.tar.gz -C /home/common/
rm /home/common/cayenne-2.0.4.tar.gz

# Add Tomcat home directory
[ ! -e /home/common/tomcat ] && mkdir /home/common/tomcat
# Define commonly used environmental variable
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export CAYENNE_HOME=/home/common/cayenne-2.0.4
export TOMCAT_HOME=/home/common/tomcat

# Docker
sudo docker pull tomcat:8-jre8
sudo docker pull postgres:latest

