#!/usr/bin/env bash
 

# Install Node v0.10.37


sudo apt-get update -y

sudo apt-get install curl -y

curl -sL https://deb.nodesource.com/setup_5.x | sudo bash -
sudo apt-get install nodejs -y


#su vagrant
#and adding $HOME/.npm-packages/bin to $PATH

npm config set prefix '/home/vagrant/.npm-packages'

#append to .bashrc
export PATH="$PATH:/home/vagrant/.npm-packages/bin"
echo 'export PATH="$PATH:/home/vagrant/.npm-packages/bin"' | sudo tee -a /home/vagrant/.bashrc

export PATH="$PATH:/home/vagrant/.npm-packages/lib/node_modules"
echo 'export PATH="$PATH:/home/vagrant/.npm-packages/lib/node_modules"' | sudo tee -a /home/vagrant/.bashrc


npm install -g bower
npm install -g yo
npm install -g generator-angular-spark
npm install -g grunt-cli

export PATH="$PATH:/home/vagrant/.npm-packages/lib/node_modules/grunt-cli/bin"
echo 'export PATH="$PATH:/home/vagrant/.npm-packages/lib/node_modules/grunt-cli/bin"' | sudo tee -a /home/vagrant/.bashrc

#For start the project, i the root project
#npm install
#bower install

