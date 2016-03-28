#!/usr/bin/env bash
#this script builds a vagrant box and exports it to vagrant-java-docker.box

#furthermore it fixes the current VirtualBox tools, because docker exchanges the kernel..."
rm -f ubuntu-java-docker.box
vagrant plugin install vagrant-vbguest
echo "Remove old base box and build new one..."
vagrant destroy -f
vagrant up
vagrant halt
echo "Updating virtualbox tools, mount error is expected behaviour..."
vagrant up
vagrant vbguest --do install
vagrant halt
echo "Do cleanup..."
vagrant up
vagrant ssh -c "sudo /vagrant/bootstrap/cleanup.sh"
echo "Start packaging base box..."
vagrant package --output ubuntu-java-docker.box