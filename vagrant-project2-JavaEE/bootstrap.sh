#!/usr/bin/env bash
# install java jdk 7u1
sudo yum -y install java-1.7.0-openjdk.x86_64

# install Tomcat7
sudo cd /tmp
sudo wget http://apache.cu.be/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59.tar.gz
sudo tar xzf apache-tomcat-7.0.59.tar.gz
sudo mv apache-tomcat-7.0.59 /usr/local/tomcat7
sudo cd /usr/local/tomcat7

#Permissions
sudo chmod +x /usr/local/tomcat7/bin/startup.sh
sudo chmod +x /usr/local/tomcat7/bin/catalina.sh
sudo /usr/local/tomcat7/bin/startup.sh

#Edit the users file so managing tomcat becomes possible
sudo chcon -t public_content_t /usr/local/tomcat7/conf/tomcat-users.xml
sudo sed -i "36i <role rolename=\"manager-gui\"/>" /usr/local/tomcat7/conf/tomcat-users.xml
sudo sed -i "37i <role rolename=\"manager-script\"/>" /usr/local/tomcat7/conf/tomcat-users.xml
sudo sed -i "38i <role rolename=\"manager-jmx\"/>" /usr/local/tomcat7/conf/tomcat-users.xml
sudo sed -i "39i <role rolename=\"manager-status\"/>" /usr/local/tomcat7/conf/tomcat-users.xml
sudo sed -i "40i <role rolename=\"admin-gui\"/>" /usr/local/tomcat7/conf/tomcat-users.xml
sudo sed -i "41i <role rolename=\"admin-script\"/>" /usr/local/tomcat7/conf/tomcat-users.xml
sudo sed -i "42i <user username=\"vagrant\" password=\"vagrant\" roles=\"manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script\"/>" /usr/local/tomcat7/conf/tomcat-users.xml

sudo /usr/local/tomcat7/bin/catalina.sh stop
sudo /usr/local/tomcat7/bin/catalina.sh start

# firewall/ip forwarding so we can acces http://192.168.33.23:8080
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --reload

# install git (optional)
sudo yum -y install git
