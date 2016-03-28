#!/usr/bin/env bash

echo "Trimming down..."

#trim down Vagrant box
#-> https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one

apt-get clean -y
apt-get autoremove -y
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

cat /dev/null > ~/.bash_history && history -c

shutdown -h now