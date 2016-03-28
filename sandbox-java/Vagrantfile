# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty64'

  config.vm.synced_folder './workspace', '/home/vagrant/workspace'

  config.vm.provider "virtualbox" do |vb|
    # vb.gui = true
    vb.name = 'java-dev-box'
    vb.memory = '2048'
    vb.cpus = '2'
  end

  config.vm.provision 'file', source: '~/.gitconfig', destination: '.gitconfig'

  config.librarian_chef.cheffile_dir = "chef"
  config.vm.provision 'chef_solo' do |chef|
    # chef.log_level = :debug
    chef.cookbooks_path = ['chef/cookbooks', 'chef/site-cookbooks']
    chef.roles_path = ['chef/roles']
    chef.run_list = [
      # 'recipe[apt]',
      # 'recipe[preinstall]',
      # 'recipe[build-essential]',
      'role[base]'
       # 'recipe[java]'
      # 'recipe[maven]',
      # 'recipe[git]',
      # 'recipe[firefox]',
      # 'recipe[idea]'
      # 'recipe[xfce4]'
    ]
  end
end
