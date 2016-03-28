# vm_ubuntu14postgres94postgis21java8tomcat7
Vagrant virtual machine with Ubuntu 14 Trusty Tahr + Postgres 9.4 + Postgis 2.1 + Oracle Java 8 + Tomcat7

## Postgres

User/password postgres/postgres

Port: guest: 5432, host: 4432

### Postgis

If Postgis is needed it must be activated on schema by those commands:

```sh
sudo -u postgres psql -c"CREATE SCHEMA my_schema";
sudo -u postgres psql -c"ALTER USER postgres set SCHEMA 'my_schema'";
sudo -u postgres psql -c"CREATE EXTENSION postgis SCHEMA my_schema";
```

## Tomcat

Tomcat logs are visible in host folder **logs**

Admin user/password tomcat/tomcat

'Manager' installed

Port: guest: 8080, host: 7070

## FAQ

Why not Tomcat8?

Tomcat 7 has standard installer for Ubuntu. It provides standard setup (user, folder, autostart) and keeps Vagrantfile simple.
That is also reason why Ubuntu is choosen: CentOS has no standard installer for Tomcat (any)
