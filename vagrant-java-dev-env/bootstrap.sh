#!/bin/sh -e

# Edit the following to change the db credentials:
APP_DB_USER=test
APP_DB_PASS=test

# Edit the following to change the version of PostgreSQL that is installed
PG_VERSION=9.3

# Update package list and upgrade all packages
apt-get update
apt-get -y upgrade

apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION"

PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

AT_ENV_VAR="~/.bashrc"

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

# Append to pg_hba.conf to add password auth:
echo "host    all             all             all                     md5" >> "$PG_HBA"

# Explicitly set default client_encoding
echo "client_encoding = utf8" >> "$PG_CONF"

# Restart so that all new config is loaded:
service postgresql restart

cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';
EOF

echo "Successfully created PostgreSQL dev virtual machine."
echo ""


echo "Installing JDK 1.7"
sudo apt-get -y install openjdk-7-jdk
echo "Java JDK successfuly installed"

#install tomcat if does not exist
if [ ! -d /opt/tomcat7 ]; then
	echo "Installing Apache Tomcat 7"
   	cd /tmp
   	sudo wget http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59.tar.gz
   	sudo tar zxf apache-tomcat-7.0.59.tar.gz
   	sudo mv apache-tomcat-7.0.59 /opt/tomcat7
   	sudo chown -R vagrant /opt/tomcat7
   	cd ~
   	echo "Apache Tomcat 7 successfuly installed"
fi
