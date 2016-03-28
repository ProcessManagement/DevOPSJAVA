# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "hashicorp/precise64"
  config.vm.hostname = "vagrant"

  # Database exposure
  config.vm.network "forwarded_port", guest: 5432, host: 5432

  # Proxy exposure
  config.vm.network "forwarded_port", guest: 8080, host: 18080

  config.vm.provision :shell, :path => "server/upgrade_puppet.sh"
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "server/manifests"
    puppet.module_path = "server/modules"
    puppet.manifest_file  = "site.pp"
    puppet.options << '--fileserverconfig /vagrant/server/filesserver.conf'
  end

end
