#!/usr/bin/env bash

# change this to tell Jenv which Java version to load by default.
JAVA_VERSION=8  # 7 or 6


# make sure the vm is up and running
while [ "`runlevel`" = "unknown" ]; do
	echo "runleel is 'unknown' - waiting for 10s"
	sleep 10
done
echo "runlevel is now valid ('`runlevel`'), kicking off provisioning..."

# become the main user, not root
su vagrant

# equip the base image
sudo apt-get update -y
sudo apt-get install build-essential rsync telnet screen man wget -y
sudo apt-get install strace tcpdump -y
sudo apt-get install libssl-dev zlib1g-dev libcurl3-dev libxslt-dev -y
sudo apt-get install software-properties-common python-software-properties -y
sudo apt-get install git -y
sudo apt-get install curl -y

# Install Oracle Java 6
curl -L --cookie "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin -o jdk-6-linux-x64.bin
chmod u+x jdk-6-linux-x64.bin
./jdk-6-linux-x64.bin
sudo mkdir -p /usr/lib/jvm
sudo mv ./jdk1.6.* /usr/lib/jvm/
sudo chown -R root:root /usr/lib/jvm/jdk1.6.0_45
rm jdk-6-linux-x64.bin

# Install Oracle Java 7
curl -L --cookie "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz -o jdk-7-linux-x64.tar.gz
tar xfvz jdk-7-linux-x64.tar.gz
sudo mkdir -p /usr/lib/jvm
sudo mv ./jdk1.7.* /usr/lib/jvm/
sudo chown -R root:root /usr/lib/jvm/jdk1.7.0_65
rm jdk-7-linux-x64.tar.gz

# Install Oracle Java 8
curl -L --cookie "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u40-b26/jdk-8u40-linux-x64.tar.gz -o jdk-8-linux-x64.tar.gz
tar xfvz jdk-8-linux-x64.tar.gz
sudo mkdir -p /usr/lib/jvm
sudo mv ./jdk1.8.* /usr/lib/jvm/
sudo chown -R root:root /usr/lib/jvm/jdk1.8.0_40
rm jdk-8-linux-x64.tar.gz

# chmod executables
# sudo chmod a+x /usr/bin/java
# sudo chmod a+x /usr/bin/javac
# sudo chmod a+x /usr/bin/javaws

# Install Jenv
export JENV_ROOT=/usr/local/lib/jenv
git clone https://github.com/gcuisinier/jenv.git $JENV_ROOT
sudo chown -R vagrant:root $JENV_ROOT
echo 'export PATH="/usr/local/lib/jenv/bin:$PATH"' >> /home/vagrant/.bashrc
echo 'eval "$(jenv init -)"' >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc
chown vagrant:root /home/vagrant/.bashrc
###### ADD MORE JAVA VERSIONS HERE ######
$JENV_ROOT/bin/jenv add /usr/lib/jvm/jdk1.6.0_45
$JENV_ROOT/bin/jenv add /usr/lib/jvm/jdk1.7.0_65
$JENV_ROOT/bin/jenv add /usr/lib/jvm/jdk1.8.0_40
#########################################
$JENV_ROOT/bin/jenv versions
echo "Selecting Java version ${JAVA_VERSION}"
$JENV_ROOT/bin/jenv global oracle64-1.8.0.40  # set Java8 to default.
$JENV_ROOT/bin/jenv versions

export $HOME=/home/vagrant

# # Install Jenv
# sudo apt-get install zip -y
# sudo apt-get install unzip -y
# curl -L -s get.jenv.io | bash
# source /home/vagrant/.jenv/bin/jenv-init.sh

# rm -f equip_base.sh
# rm -f equip_java7_64.sh

echo "export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_40" >> /home/vagrant/.bashrc

java -version

# Install Apache ANT
echo "Downloading Ant 1.9.4...."
wget --quiet http://apache.mirrors.pair.com/ant/binaries/apache-ant-1.9.4-bin.tar.gz
tar xfvz apache-ant-1.9.4-bin.tar.gz
sudo mv apache-ant-1.9.4 /usr/local
sudo ln -s /usr/local/apache-ant-1.9.4/bin/ant /usr/bin/ant
rm apache-ant-1.9.4-bin.tar.gz

# Install Apache Maven
echo "Downloading Maven 3.3.1...."
wget --quiet http://supergsego.com/apache/maven/maven-3/3.3.1/binaries/apache-maven-3.3.1-bin.tar.gz
tar xfvz apache-maven-3.3.1-bin.tar.gz
sudo mv apache-maven-3.3.1 /usr/local
sudo ln -s /usr/local/apache-maven-3.3.1/bin/mvn /usr/bin/mvn
rm apache-maven-3.3.1-bin.tar.gz

# Set Java home
export JAVA_HOME=/usr/lib/jvm/jdk1.7.0_65

completion_msg="
===========================================
Completed Provision of Java Dev Environment
===========================================
Installed are:
  - Java JDK 6u45
  - Java JDK 7u65
  - Java JDK 8u40
  - Jenv (defaults to Java8)
  - Apache Ant 1.9.4
  - Maven 3.3.1
===========================================
Happy Coding!
"
echo "$completion_msg"
