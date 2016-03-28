# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Box to build off of.
  config.vm.box = "CentOS6.5"
  config.vm.box_url = "https://googledrive.com/host/0B4tZlTbOXHYWVGpHRWZuTThGVUE/centos65_virtualbox_50G.box"

  # Enable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`.
  config.vm.box_check_update = true

  # Create a private network, which allows host-only access to the machine
  # using a static IP.
  config.vm.network :private_network, ip: "172.28.128.5", :netmask => "255.255.0.0", adapter: 2
  # Provision Docker via a shell script
  config.vm.provision "shell", :path => "vagrant_config/deploy_docker.sh" do |s|
      s.args = "-i 172.28.128.5 -h projects"
  end

  # Deploy Java and Maven
  config.vm.provision "shell", path: "vagrant_config/deploy_mvn.sh"

  # Allocate 4GB RAM and 2 CPUs
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", 4096]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end
end
