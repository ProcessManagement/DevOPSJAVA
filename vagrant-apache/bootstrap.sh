#!/usr/bin/env bash

apt-get update
apt-get install -y apache2
sudo rm -rf /var/www
sudo ln -fs /vagrant/www /var/www
