Vagrant.configure(2) do |config|
  config.vm.box = "umrigark/centos6.6"
    
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end
  # Shell provisioning
  config.vm.provision "shell" do |s|
  	s.path = "installjava.sh"
  end
  config.vm.provision "shell" do |t|
      t.path = "dockersetup.sh"
  end
end
