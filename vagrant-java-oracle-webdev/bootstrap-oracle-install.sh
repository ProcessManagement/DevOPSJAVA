#via silent install
#http://docs.oracle.com/cd/B25329_01/doc/install.102/b25144/toc.htm#BABCCGCF
sudo rpm -Uvh /vagrant/Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm

#open up oracle ports
sudo iptables -I INPUT 4 -p tcp -m state --state NEW -m tcp --dport 8090 -j ACCEPT
sudo iptables -I INPUT 4 -p tcp -m state --state NEW -m tcp --dport 1521 -j ACCEPT

sudo service iptables save

sudo /etc/init.d/oracle-xe configure < /vagrant/oracle-input

#run environment variable configuration
. /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh

#run for vagrant user on login
echo -e "\n#Sets Up Oracle Environment Variables\n" >> /home/vagrant/.bash_profile
echo . /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh >> /home/vagrant/.bash_profile

/vagrant/oracle-apex-setup.sh