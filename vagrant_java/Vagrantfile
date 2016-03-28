# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "box-cutter/ubuntu1504-desktop"

  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
    v.customize ["modifyvm", :id, "--memory", "4096"]
    v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    v.customize ["modifyvm", :id, "--cpus", "4"]
    v.customize ["modifyvm", :id, "--vram", "128"]
    v.customize ["modifyvm", :id, "--nestedpaging", "on"]
  end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "gnome-do"
    chef.add_recipe "git"
    chef.add_recipe "vim"
    chef.add_recipe "awesome_vim"
    chef.add_recipe "java"
    chef.add_recipe "maven" 
    chef.add_recipe "idea::default"

    chef.json = {
      "java" => { 
        "set_etc_enviornment" => true,
        "install_flavor" => "oracle", 
        "jdk_version" => "8", 
        "set_default" => true,
        "oracle" => { 
          "accept_oracle_download_terms" => true 
        } 
      }
    }
  end
end
