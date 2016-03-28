# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config| 
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

#  config.vm.network :hostonly, "10.10.10.2"

#  config.vm.share_folder "work", "/var/www", "./work", :owner => "www-data"

  config.vm.provision :puppet do |puppet|
	puppet.manifests_path = "puppet/manifests"
	puppet.manifest_file = "default.pp"
	puppet.module_path = "puppet/modules"
  end
end
