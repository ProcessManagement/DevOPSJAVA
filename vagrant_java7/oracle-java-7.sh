
echo debconf shared/accepted-oracle-license-v1-1 select true | \
      sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | \
      sudo debconf-set-selections apt-get update

sudo apt-get update
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get install -y  oracle-java7-installer
sudo apt-get install -y maven
