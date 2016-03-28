# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-6.5-64-nocm"
  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.network "forwarded_port", guest: 8080, host: 2280
  config.vm.network "forwarded_port", guest: 8090, host: 2290
  config.vm.network "forwarded_port", guest: 1521, host: 1521

  #config.vbguest.auto_update = false
end
