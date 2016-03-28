# Debian 8.2/Desktop Vagrant setup for Developers

This is just a Vagrant setup for an Debian VirtuaBox for developers. The VM contains:

* Debian 8.2
* Mate-Desktop
* postgresql
* atom
* git
* jdk8
* rvm with ruby 2.2.x installed
* chrome browser
* docker + docker-compose
* node.js + npm

## Prerequisist

* [Virtual Box](https://www.virtualbox.org) 5.0.14 (may work with VMWare also); If you want to use anohter version of VirtualBox, you have to modify the installation of VirtualBox-Additions in `bootstrap.sh`.
* Install Vagrant: https://www.vagrantup.com/downloads.html
* Install [Vagrant Proxy Conf](https://github.com/tmatilai/vagrant-proxyconf): `vagrant plugin install vagrant-proxyconf`
* Install [Vagrant VBGuest-Plugin](https://github.com/tmatilai/vagrant-proxyconf): `vagrant plugin install vagrant-vbguest`
* start VirtualBox and configure the path you want your virtual boxes to be stored
* If you want to dynamically add another disk to your vm, the add pthe ath of `VirtualBoxManage` to your system's PATH environment variable
* the path of the folder where your VirtualBox installation stores the virtual machine disks in should not contain any spaces or special characters

## Adjust to your needs

### Keyboad mapping

In the first lines of `bootstrap.sh` keyboard mappings for PC and Mac are defined. Select the ones you need, adjust them if you wand and remove or comment the other ones.

### Proxy setup

If you're virtual machine is behind a proxy by setting the following environment variables before starting the vagrant box (Vagrant Proxy Conf needed, see above):
* VAGRANT_HTTP_PROXY
* VAGRANT_HTTPS_PROXY
* VAGRANT_FTP_PROXY

User credentials may be part of the settings, e.g. `export VAGRANT_HTTP_PROXY=http://hanswurst:mysecret@myproxy.example.com:8080`

In your virtual machine the proxy configuration will then be set automatically for:
* Apt
* Docker
* Git
* npm
* atom


### Virtual Disks

The base configuration of the virtual machine contains one disk of 40 GB. The Vagrantfile contains the definition of an additional disk of 20 GB with is mounted to /var/lib/docker. You can change it's size in the `Vagrantfile` if you like. This disk is for your docker development. It's the place where docker stores all images and containers in. A separate disk makes sense, because when working with docker a lot of space is needed in /var/lib/docker and you do not want your system partition to run out of free disk space.



You may add another disk to your vm if you like.


### Port forwarding

The Vagrant file contains a setup for forwarding some ports you might need during development of ruby or java applications. Modify them if you like.


### Mounted folders

The following folders are mounted into the VM:

* local folder where Vagrantfile is in -> /vagrant

Add additional folders to the `Vagrantfile` if you like.


### SSH keys

If you need special ssh keys you already have, just place them into the folder `customize/ssh-keys`. This allows you to ssh to  machines without entering login/password. Be aware `authorized_keys` will not be copied, but instead automatically removed from the folder.

### Additional software / system modification

 If you want to change the setup of the VM or you need extra software you may modify `bootstrap.sh`. Afterwards you have to do `vagrant provision`.  Do this only, if you absolutely know what this is all about.

## Running

After you have adjust the machines configuration you can start it as follows (form the directory `Vagrantfile` resides):

`vagrant up`

If you do this the fist time, it may take several minutes, because all artifacts will be loaded from the internet. Be patient and wait until the setup is complete. The stop the virtual machine:

`vagrant stop`

Now you can run it everytime with:

`vagrant up`

If you start the virtual machine from the VirtualBox Manager, you cannot change the proxy settings and you shoud enable "automount" for all attached disks before. Otherwise you won't have them inside your machine.

## login

Autologin is activated. The user is `vagrant` and the password is `vagrant`. This is a sudo-user who is allowed to do all (with `sudo`).

# License & Warranty

This is just my personal setup. It comes without any warranty. The contained and referenced software artifacts have all their own licenses. I tried to setup  this machine with open source software or freeware only, but I am no responsible for the right use of software & licenses in your enivironment.
