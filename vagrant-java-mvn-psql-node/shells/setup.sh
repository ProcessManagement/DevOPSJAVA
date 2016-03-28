#!/bin/bash
#sudo echo "debian8" > /etc/hostname
#sudo hostname -F /etc/hostname
#sudo ip=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
#sudo echo "$ip   $ip hostname" >> /etc/hosts
#sudo ln -sf /usr/share/zoneinfo/EST /etc/localtime
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install software-properties-common python-software-properties -y