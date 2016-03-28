# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.

  config.vm.box = "ubuntu/trusty64"
  # this VM is based on the predefined box ubuntu/trusty64 that is available from the following URL  https://atlas.hashicorp.com/ubuntu/boxes/trusty64
  # note: the box will be downloaded from that URL if Vagrant cannot not find it locally (in the Vagrant home - by default: HOME/.vagrant.d/boxes))

  config.vm.hostname = "base.dev.amis"

  # added based on http://garylarizza.com/blog/2013/02/01/repeatable-puppet-development-with-vagrant/ and https://github.com/hashicorp/puppet-bootstrap/blob/master/ubuntu.sh
  # this script prepared the image for use of Puppet (one of several ways of doing that)
  config.vm.provision :shell, :path => "ubuntu.sh"  

  
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # any network request on the host made to the specified port (8888 or 1521) should be forwarded into the VM and handled there
  config.vm.network :forwarded_port, guest: 8080, host: 8888
  config.vm.network :forwarded_port, guest: 1521, host: 1521
  # also forward requests to port 7101 in the VM - that is where the JDeveloper Integrated WebLogic Server is typically running
  config.vm.network :forwarded_port, guest: 7101, host: 7501
  config.vm.network :forwarded_port, guest: 7102, host: 7502

  
  
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  
  config.vm.synced_folder "c:/temp", "/host_temp"

  config.vm.synced_folder "files", "/etc/puppet/files"
  config.vm.synced_folder "files", "/vagrant", :mount_options => ["dmode=777","fmode=777"]

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]	
    vb.customize ["modifyvm", :id, "--vram", "32"]
    vb.gui = true
    vb.name = "Base VM with Ubuntu 14.0.4, Desktop and Java; support for Puppet, Git"
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with CFEngine. CFEngine Community packages are
  # automatically installed. For example, configure the host as a
  # policy server and optionally a policy file to run:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.am_policy_hub = true
  #   # cf.run_file = "motd.cf"
  # end
  #
  # You can also configure and bootstrap a client to an existing
  # policy server:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.policy_server_address = "10.0.2.15"
  # end

  

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path    = "modules"
    puppet.manifest_file  = "base.pp"
   # puppet.options ="--verbose --debug"  
  end

end
