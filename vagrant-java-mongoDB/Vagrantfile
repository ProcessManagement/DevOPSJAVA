# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

class ::Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end
end

Vagrant.configure("2") do |config|

  extConfigDefault = {
    'vagrant' => {
      'machine' => {
        'hostname' => 'c.dev',
        'aliases' => [],
        'memory' => '2048',
        'nfs' => true
      }
    }
  }
  extConfig = YAML.load_file('config.yml')
  extConfig = extConfigDefault.deep_merge extConfig

  config.vm.box = "trusty64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.network :private_network, ip: "33.33.0.70"
  config.vm.hostname = extConfig['vagrant']['machine']['hostname']
  config.hostsupdater.aliases = extConfig['vagrant']['machine']['aliases']

  config.vm.provider :virtualbox do |vb|
    vb.name = "Dev Environment 1"
    vb.customize ["modifyvm", :id, "--memory", extConfig['vagrant']['machine']['memory']]
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/graph", "1"]
  end

  config.vm.synced_folder extConfig['vagrant']['share_path'], "/home/vagrant/shared/", id: "vagrant-root", :nfs => extConfig['vagrant']['machine']['nfs']

  config.vm.provision :shell, :inline => "apt-get install ruby1.9.1-dev"
  config.vm.provision :shell, :inline => "gem install chef --version 10.30.2 --no-rdoc --no-ri --conservative"
  config.vm.provision :chef_solo do |chef|
    chef.log_level = "info"
    chef.cookbooks_path = "./cookbooks"
    chef.add_recipe "apt"
    chef.add_recipe "build-essential"
    chef.add_recipe "git"
    chef.add_recipe "vim"
    chef.add_recipe "postfix"
    chef.add_recipe "openssl"
    chef.add_recipe "apache2"
    chef.add_recipe "mysql"
    chef.add_recipe "mysql::server"
    chef.add_recipe "memcached"
    chef.add_recipe "java"
    chef.add_recipe "php"
    chef.add_recipe "php::module_apc"
    chef.add_recipe "php::module_curl"
    chef.add_recipe "php::module_mysql"
    chef.add_recipe "php::module_gd"
    chef.add_recipe "php::module_memcache"
    chef.add_recipe "php::module_ldap"
    chef.add_recipe "apache2::mod_php5"
    chef.add_recipe "apache2::mod_rewrite"
    chef.add_recipe "apache2::mod_ssl"
    chef.add_recipe "apache2::mod_dir"
    chef.add_recipe "apache2::mod_alias"
    chef.add_recipe "composer"
    chef.add_recipe "misc::packages"
    chef.add_recipe "misc::vhost"
    chef.add_recipe "misc::environment"
    chef.json = {
      "apache" => {
        "user" => "vagrant",
        "group" => "vagrant",
        "version" => "2.4"
      },
      "php" => {
        "ext_conf_dir" => "/etc/php5/mods-available"
      },
      "mysql" => {
        "server_root_password" => "root",
        "server_repl_password" => "root",
        "server_debian_password" => "root",
        "bind_address" => "33.33.0.70",
        "allow_remote_root" => true
      },
      "misc" => {
        "docroot" => "/home/vagrant/shared",
        "mongo" => {
          "apt_repo" => "ubuntu-upstart"
        },
        "packages" => [
          "mongodb-10gen",
          "nodejs",
          "php5-xdebug",
          "nfs-common",
          "portmap",
          "sphinxsearch"
        ]
      }
    }
  end

end
