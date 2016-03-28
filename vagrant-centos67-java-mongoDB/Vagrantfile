# -*- mode: ruby -*-
# vi: set ft=ruby :

BRANCH = ENV['BRANCH'] || "master"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
#  config.vm.box = "ubuntu/trusty64"
  #config.vm.box = "kalranitin/centos66-ansible-docker"
  config.vm.box = "box-cutter/centos67-docker"

#  config.vm.box = "centos-gui"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.provision :shell, :path => "provision.sh", :args => "-b" + BRANCH
  config.vm.provider "virtualbox" do |v|
    v.gui = false
    v.memory = 2048
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vbguest.auto_update = false

end
