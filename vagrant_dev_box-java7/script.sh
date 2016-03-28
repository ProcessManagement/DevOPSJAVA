#!/bin/bash -x

echo "Starting to provision your system..."

# To install default settings and not prompt user settings during installation
export DEBIAN_FRONTEND=noninteractive

apt-get update

# To install important packages like gcc, g++, git and others:
apt-get install -y build-essential git curl tree vim
apt-get install -y bash-completion zlib1g-dev libssl-dev libreadline-dev bash-completion libyaml-dev libcurl4-gnutls-dev libsqlite3-dev apache2-threaded-dev

# To allow adding to apt repo & install Python related packages
apt-get install -y python-software-properties python-pip python-dev

# To install Oracle Java7
add-apt-repository -y ppa:webupd8team/java
apt-get update
# To accept the license
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
apt-get install -y oracle-java7-installer

# To install RVM, Ruby, and Rails
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -L https://get.rvm.io | bash -s stable --autolibs=enable
source /etc/profile.d/rvm.sh
source ~/.rvm/scripts/rvm
source "$HOME/.profile"
source "$HOME/.bash_profile"
rvm requirements
rvm reload

_RUBY_VERSION="ruby-2.1.3"
rvm install $_RUBY_VERSION
rvm use $_RUBY_VERSION --default
gem update
rvm rubygems current
gem install rails --no-ri --no-rdoc

echo "Done provisioning. For your Rails app, browse using 127.0.0.1:3000"
