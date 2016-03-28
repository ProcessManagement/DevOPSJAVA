# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos6.5"
  config.vm.box_url = "http://www.lyricalsoftware.com/downloads/centos65.box"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.provision "shell", :path => "prov/java8.sh"
end
