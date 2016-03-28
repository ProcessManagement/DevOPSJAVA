# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bento/debian-8.2"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3000, host: 3030 , host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 5000, host: 5000 , host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 5555, host: 5555 , host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 8080, host: 8180 , host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 8081, host: 8081 , host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 8082, host: 8082 , host_ip: "127.0.0.1"


  config.vm.network "private_network", ip: "192.168.50.4", virtualbox__intnet: true

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "~/Downloads", "/home/vagrant/Downloads", create: true
  config.vm.synced_folder ".", "/vagrant",  create: true
  #config.vm.synced_folder "D:/Workspace", "/home/vagrant/Workspace",  create: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = true

    vb.name = "debian-8-mate"

    vb.customize ["modifyvm", :id, "--memory", 8192]
    vb.customize ["modifyvm", :id, "--vram", 64]
    vb.customize ["modifyvm", :id, "--accelerate3d", "off"]

    # proxy configuration, you have to 'vagrant plugin install vagrant-proxyconf'
    # set the following environment variables before starting vagrant
    # VAGRANT_HTTP_PROXY
    # VAGRANT_HTTPS_PROXY
    # VAGRANT_FTP_PROXY

    ## Create a second disk, e.g. for use with docker
    #line = `VBoxManage list systemproperties | grep "Default machine folder"`
    #vb_machine_folder = line.split(':')[1].strip()
    #puts vb_machine_folder
    #puts vb.name
    #second_disk = File.join(vb_machine_folder, vb.name, 'docker.vdi')
    ## Create and attach disk
    #unless File.exist?(second_disk)
    #  # 20 * 1024 = 20 GB
    #  vb.customize ['createhd', '--filename', second_disk, '--format', 'VDI', '--size', 20 * 1024]
    #end
    #vb.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', second_disk]

  end

  # provide eveything neeeded into the virtual box
  #config.vm.provision "fix-no-tty", type: "shell" do |s|
  #  s.privileged = false
  #  s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  #end
  config.vm.provision :shell, path: "bootstrap.sh"
end
