# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "precise32"

  # config.vm.box_check_update = false

  # config.vm.network "forwarded_port", guest: 7199, host: 7199
  # config.vm.network "forwarded_port", guest: 7000, host: 7000
  # config.vm.network "forwarded_port", guest: 7001, host: 7001
  # config.vm.network "forwarded_port", guest: 9160, host: 9160
  # config.vm.network "forwarded_port", guest: 9042, host: 9042

  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "public_network"
  # config.ssh.forward_agent = true
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provision :shell do |shell|
    shell.inline = "mkdir -p /etc/puppet/modules;
      puppet module install puppetlabs/apt"
  end

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "default.pp"
    puppet.options = "--verbose --debug"
  end

end
