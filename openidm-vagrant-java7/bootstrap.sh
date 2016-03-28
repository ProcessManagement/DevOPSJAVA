#!/usr/bin/env bash
apt-get update
apt-get install -y unattended-upgrades 
apt-get install -y unzip
apt-get install -y software-properties-common
echo "[+] Common Files Done"
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
echo "[+] Keys added"
apt-get update
echo "[+] added licence"
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install -y oracle-java7-installer
echo "[+] added Java"
update-java-alternatives -s java-7-oracle
wget -O /tmp/openidm.zip https://github.com/OpenRock/OpenIDM/releases/download/3.1.0/openidm-3.1.0.zip
sudo unzip /tmp/openidm.zip -d /opt/
rm /tmp/openidm.zip
echo "[+] Added Startup to Crontab"
echo '@reboot root /opt/openidm/startup.sh' > /etc/cron.d/openidm
echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle/" >> /home/vagrant/.bashrc
echo "PATH=$PATH:$HOME/bin:$JAVA_HOME/bin" >> /home/vagrant/.bashrc
echo "export JAVA_HOME" >> /home/vagrant/.bashrc
echo "export JRE_HOME" >> /home/vagrant/.bashrc
echo "export PATH" >> /home/vagrant/.bashrc
echo "[+] Going down for reboot"
sleep 5s
reboot
