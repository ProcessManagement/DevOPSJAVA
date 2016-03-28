Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "node1" do |node|
    node.vm.box = "origin"
    node.vm.box_url = "http://www.meread.com/share/virtualbox-centos7.box"
    node.vm.provider "virtualbox" do |v|
      v.name = "node1"
      v.customize ["modifyvm", :id, "--memory", "1536"]
    end
    node.vm.network :private_network, ip: "11.11.11.101"
    node.vm.hostname = "node1"
    node.vm.provision "shell", inline: <<-SHELL
      /etc/rc.d/init.d/mysql bootstrap
    SHELL
  end
  (2..3).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.box = "origin"
      node.vm.box_url = "http://www.meread.com/share/virtualbox-centos7.box"
      node.vm.provider "virtualbox" do |v|
        v.name = "node#{i}"
        v.customize ["modifyvm", :id, "--memory", "1536"]
      end
      node.vm.network :private_network, ip: "11.11.11.10#{i}"
      node.vm.hostname = "node#{i}"
      node.vm.provision "shell", inline: <<-SHELL
        systemctl start mysql
      SHELL
    end
  end
  config.vm.define "haproxy" do |node|
    node.vm.box = "origin"
    node.vm.provider "virtualbox" do |v|
      v.name = "haproxy"
      v.customize ["modifyvm", :id, "--memory", "1024"]
    end
    node.vm.network :private_network, ip: "11.11.11.104"
    node.vm.hostname = "haproxy"
  end
end
