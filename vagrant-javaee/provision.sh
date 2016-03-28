#!/bin/bash

add-apt-repository -y ppa:webupd8team/java

apt-get -y update

#install jdk 8
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections 
apt-get install -y oracle-java8-installer
apt-get install -y oracle-java8-set-default

# install ubuntu desktop
apt-get install -y ubuntu-desktop

# #Install glassfish
cd /tmp
wget 'http://download.java.net/glassfish/4.1/release/glassfish-4.1.zip'
unzip glassfish-4.1*zip -d /home/vagrant
rm glassfish-4.1.zip -f
sudo chmod -R 777 /home/vagrant/glassfish4

#install eclipse mars
cd /tmp
wget 'http://archive.eclipse.org/technology/epp/downloads/release/mars/M1/eclipse-jee-mars-M1-linux-gtk-x86_64.tar.gz'
cd /home/vagrant
tar -zxvf /tmp/eclipse-*.tar.gz 
cp /vagrant/install/eclipse.desktop /usr/share/applications/
desktop-file-install /usr/share/applications/eclipse.desktop
ln -s /home/vagrant/eclipse/eclipse /usr/local/bin/
chmod -R 777 /home/vagrant/eclipse

apt-get install -y ubuntu-desktop
apt-get -y update
# apt-get -y install linux-headers-generic

adduser vagrant sudo