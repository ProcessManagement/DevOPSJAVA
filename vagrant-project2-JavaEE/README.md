# vagrant-project2

### Contents
This repository contains vagrant projects and files for:
  - LAMP stack (centos7 minimal) - mariadb/mysql is installed but needs some work to be setup the way you want it to work (https://mariadb.com/kb/en/mariadb/mysqladmin/)
  - Java EE stack (centos7 minimal)
  - Centos7 DHCP (centos7 minimal) basic server setup.

### Some info
Hold in mind these vagrant setups are very basic, they will only install the necessary software and make you able to work with the basics of both stacks (hosting websites, etc). The vagrantfile will automaticly download the centos box that is needed.

You can acces the lamp stack through http://192.168.33.22 (from your host) and the java stack through http://192.168.33.23:8080 to test if everything works.

Managing tomcat can be done through the manager app on adress http://192.168.33.23:8080 (username: vagrant , password: vagrant)

The DHCP server sets up an internal network for a 192.168.101.0 subnet. Feel free to change whatever you like to your own needs.

### Synced folders
- LAMP: app folder on host is shared with /var/www/html/.
- JAVA: webapps folder is shared with /home/webapps/. You'll have to move your files on your guest from the /home/webapps folder to the /usr/local/tomcat7/webapps folder to use them. The folder isn't directly synced with /usr/local/tomcat7/webapps due to a problem with a tar extraction and renaming (folder already exists at start because of vagrantfile synced folder).
- DHCP: app folder is shared with the /home/app folder.

### Downloads
- Download vagrant from: https://www.vagrantup.com/downloads.html
- Download virtualbox from: https://www.virtualbox.org/wiki/Downloads

