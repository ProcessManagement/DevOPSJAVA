echo **************************
echo Installing xfce4
echo **************************
sudo apt-get install gdm
sudo dpkg-reconfigure gdm
sudo apt-get install gnome-terminal

echo **************************
echo DOWNLOAD JAVA 9 INSTALLER
echo **************************
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update

echo **************************
echo INSTALL JAVA 9
echo **************************
mkdir /usr/local/java
cd /usr/local/java
sudo wget http://www.java.net/download/jigsaw/archive/b83/binaries/jigsaw-jdk-bin-linux-x64.tar.gz
tar xf jigsaw-jdk-bin-linux-x64.tar.gz

# the installer in the repository does not currently include Jigsaw
#echo oracle-java9-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
#sudo apt-get -y install oracle-java9-installer
echo "JAVA_HOME=/usr/local/java/jdk1.9.0
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
export JAVA_HOME
export PATH" >> /home/vagrant/.profile

echo **************************
echo INSTALL ECLIPSE
echo **************************
mkdir /usr/local/eclipse
cd /usr/local/eclipse
sudo wget http://mirror.cc.columbia.edu/pub/software/eclipse/eclipse/downloads/drops4/S-4.6M2-201509162000/eclipse-SDK-4.6M2-linux-gtk-x86_64.tar.gz
tar xf eclipse-SDK-4.6M2-linux-gtk-x86_64.tar.gz

echo **************************
echo DONE
echo **************************
