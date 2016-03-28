# General
* Based on box-cutter/ubuntu1504-desktop
* User/password: vagrant/vagrant

# Using this VM
* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  * Note: You might have to experiment with the version of VirtualBox on Windows 7 machines due to virus scanning software
* Install [the VirtualBox Extensions](https://www.virtualbox.org/wiki/Downloads)
* Install [Vagrant](http://www.vagrantup.com/downloads)
* You'll need a unix shell and have git installed.
  * Windows users, I recommend [Git Bash](https://msysgit.github.io/)
* Clone this repo:
```bash
git clone https://github.com/schuchert/vagrant_java.git
```

* Run the first_time.sh script (you can run every time, but this installs a few vagrant plugins that are handy)
```bash
cd vagrant_java
./first_time.sh
```

# Still needs work:
The Java cookbook should be setting the right JDK, but it doesn't 
seem to (probably because I don't know what I'm doing). However, if
you provision a second time it works. So the first_time.sh starts
the vm and then immediately provisions it again. While ugly, it makes
the desktop link to idea work so it's better than that not working.

# Steps created to start this image:
* vagrant init box-cutter/ubuntu1404-desktop
* updated VirtualBox to have it match the destop extensions already installed in the downloaded box
* added several cookbooks
* installed Java manually because hotel internet too slow
