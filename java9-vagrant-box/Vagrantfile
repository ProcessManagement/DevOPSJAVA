# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.box = "ubuntu/trusty64"
    config.vm.network "private_network", ip: "169.254.46.99", name: "VirtualBox Host-Only Ethernet Adapter"
    config.vm.synced_folder "public/", "/var/public"
    config.vm.provision "shell", path:"provision.sh"

    config.vm.provider :virtualbox do |vbox|
      vbox.name = "java9-sandbox"
      vbox.customize ["modifyvm", :id, "--memory", 1024]
      vbox.customize ["modifyvm", :id, "--cpus", 2]
    end
end
