#! /bin/bash


sudo apt-get update
sudo apt-get install zip unzip

sudo apt-get install -y apache2
sudo apt-get install -y mysql-server
sudo apt-get install -y php5 php5-mysql php5-ldap php5-mcrypt php5-cli php5-json graphviz

cd /var/www

sudo wget http://downloads.sourceforge.net/project/itop/itop/2.2.0/iTop-2.2.0-2459.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fitop%2Ffiles%2F&ts=1446939722&use_mirror=tcpdiag iTop-2.2.0-2459.zip

sudo mv iTop-* iTop.zip
sudo unzip iTop.zip -d itop
rm iTop.zip

sudo chmod 777 /etc/apache2/sites-available/000-default.conf
sudo sed -i -- "s/html/itop/" /etc/apache2/sites-available/000-default.conf
sudo chmod 744 /etc/apache2/sites-available/000-default.conf

sudo chown -R www-data itop

sudo service apache2 restart
