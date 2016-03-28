#install tomcat
sudo yum install tomcat6 tomcat6-webapps tomcat6-admin-webapps tomcat6-docs-webapp -y

#installing java

#hack from http://stackoverflow.com/questions/10268583/how-to-automate-download-and-installation-of-java-jdk-on-linux
wget -nv --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.rpm -O jdk-7u75-linux-x64.rpm

#per http://docs.oracle.com/javase/7/docs/webnotes/install/linux/linux-jdk.html#install-64-rpm
sudo rpm -ivh jdk-7u75-linux-x64.rpm

#add it to alternatives
sudo alternatives --install /usr/bin/java java /usr/java/default/bin/java 1
sudo alternatives --install /usr/bin/javac javac /usr/java/default/bin/javac 1

#set the os to use the correct alternatives
echo 3 | sudo alternatives --config java
echo 3 | sudo alternatives --config javac

#open up 8080
sudo iptables -I INPUT 4 -p tcp -m state --state NEW -m tcp --dport 8080 -j ACCEPT

#save iptables
sudo service iptables save

#make a tomcat manager account
sudo sed -i '/<\/tomcat-users>/ i\
<user name="tomcat" password="password" roles="manager" \/>' /etc/tomcat6/tomcat-users.xml

#start tomcat
sudo service tomcat6 start