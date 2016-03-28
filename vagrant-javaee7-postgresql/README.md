vagrant-javaee7-postgresql
==========================
This system configuration is used during my Java EE development cycle. It includes packages like postgresql, maven, tomcat7 and Java (no openjdk).

The VM is provisioned using a Puppet script defined in the manifest folder.
At the moment is the Puppet script pre-configured for Windows use only, because I can't set the module path to relative in the VagrantFile.
All packages have the default configuration without any changes.
The OS that's being used here is Ubuntu Trusty x64
