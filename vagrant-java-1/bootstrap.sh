#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo $DEBIAN_FRONTEND

# Next line supress message 'stdin: is not a tty error'
if `tty -s`; then
   mesg n
fi

# Set time zone
apt-get install -q -y ntp
echo "ntpdate ntp.ubuntu.com pool.ntp.org" > /etc/cron.daily/ntpdate
echo "server pool.ntp.org" >> /etc/ntp.conf
echo "Europe/Amsterdam" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

# Update & upgrade
apt-get update -q -y
apt-get upgrade -q -y

# install packages
apt-get -y -q install curl git wget mercurial meld

# install java
### Unattented install, tnx to http://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option
echo debconf shared/accepted-oracle-license-v1-1 select true |  sudo debconf-set-selections

echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections  

echo 
echo
echo
echo Please wait...
echo
echo
echo 

apt-get install -q -y apt-file && apt-file update

apt-file search add-apt-repository

apt-get install -q -y python-software-properties

apt-get install -q -y software-properties-common

apt-get update && apt-get upgrade

add-apt-repository ppa:webupd8team/java

apt-get update && sudo apt-get install -q -y oracle-jdk7-installer

update-alternatives --display java

echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle/" >> /etc/environment

# install maven
apt-get install -q -y maven

# install postgress
# Edit the following to change the name of the database user that will be created:
APP_DB_USER=myapp
APP_DB_PASS=vagrant

# Edit the following to change the name of the database that is created (defaults to the user name)
APP_DB_NAME=$APP_DB_USER

# Edit the following to change the version of PostgreSQL that is installed
PG_VERSION=9.3

###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
  echo "Your PostgreSQL database has been setup and can be accessed on your local machine on the forwarded port (default: 15432)"
  echo "  Host: localhost"
  echo "  Port: 15432"
  echo "  Database: $APP_DB_NAME"
  echo "  Username: $APP_DB_USER"
  echo "  Password: $APP_DB_PASS"
  echo ""
  echo "Admin access to postgres user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo ""
  echo "psql access to app database user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost $APP_DB_NAME"
  echo ""
  echo "Env variable for application development:"
  echo "  DATABASE_URL=postgresql://$APP_DB_USER:$APP_DB_PASS@localhost:15432/$APP_DB_NAME"
  echo ""
  echo "Local command to access the database via psql:"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost -p 15432 $APP_DB_NAME"
}

export DEBIAN_FRONTEND=noninteractive

echo "export PATH=/usr/lib/postgresql/$PG_VERSION/bin/:$PATH" >> /etc/environment

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  print_db_usage
  exit
fi

PG_REPO_APT_SOURCE=/etc/apt/sources.list.d/pgdg.list
if [ ! -f "$PG_REPO_APT_SOURCE" ]
then
  # Add PG apt repo:
  echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > "$PG_REPO_APT_SOURCE"

  # Add PGDG repo key:
  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
fi

# Update package list and upgrade all packages
apt-get update
apt-get -y upgrade

apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION"

PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

# Append to pg_hba.conf to add password auth:
echo "host    all             all             all                     md5" >> "$PG_HBA"

# Restart so that all new config is loaded:
service postgresql restart

cat << EOF | su - postgres -c psql
-- Set password for user postgres
ALTER USER postgres with password 'vagrant';

-- Create the database user:
CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';

-- Create the database:
CREATE DATABASE $APP_DB_NAME WITH OWNER $APP_DB_USER;

-- Install extension pack (for pgadmin)
CREATE EXTENSION adminpack;


EOF

# Tag the provision time:
date > "$PROVISIONED_ON"

echo "Successfully created PostgreSQL dev virtual machine."
echo ""
print_db_usage
