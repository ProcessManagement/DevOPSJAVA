vagrant-java-sandbox
================

Basic Vagrant box, with Java for development with Jdk and Maven

## Things needed

### Vagrant addons
```
vagrant plugin install vagrant-librarian-chef
```
  (https://github.com/jimmycuadra/vagrant-librarian-chef)

### Chef
* https://downloads.chef.io/chef-dk 

### Still need to do properly:
* Permit anyone to start the GUI
  config.vm.provision "shell", inline: "sudo sed 
  -i 's/allowed_users=.*$/allowed_users=anybody/' /etc/X11/Xwrapper.config"
 
* config.vm.provision "shell", inline: "export JAVA_HOME='/usr/lib/jvm/java-7-openjdk-amd64/'" 

* start the gui
  config.vm.provision "shell", inline: "startxfce4 &"

* https://download.jetbrains.com/idea/ideaIC-15.0.1.tar.gz
  Download and verify the file SHA-256 checksum