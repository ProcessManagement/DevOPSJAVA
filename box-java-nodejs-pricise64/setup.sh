#!/bin/sh
mkdir -p "/home/vagrant/installs"
chmod 777 "/home/vagrant/installs"
su - vagrant -c "ssh-keygen -f /home/vagrant/.ssh/id_rsa -t rsa -N ''"
echo "******** PUBLIC KEY TO UPLOAD TO GITHUB IS ****"
cat /home/vagrant/.ssh/id_rsa.pub
sudo apt-get install curl -y -q
sudo apt-get install unzip -y -q
echo "********"
if [ ! -d "/home/vagrant/installs/h2" ]; then
	if [ ! -f /tmp/h2.zip ]; then
		curl -o /tmp/h2.zip  http://www.h2database.com/h2-2013-05-25.zip
	fi
	su - vagrant -c "cp /tmp/h2.zip /home/vagrant/installs/h2.zip; cd /home/vagrant/installs; unzip h2.zip; chmod 777 /home/vagrant/installs/h2/bin/h2.sh"
fi
