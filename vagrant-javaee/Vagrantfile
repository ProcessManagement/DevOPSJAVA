Vagrant.configure(2) do |config|
  	config.vm.box = "ubuntu/trusty64"
  	config.vm.hostname = "javaee"
  	config.vm.provision "shell", path: "provision.sh"
	
	config.vm.provider "virtualbox" do |vb|
#		Display the VirtualBox GUI when booting the machine
		vb.gui = true
  
#		Customize the amount of memory on the VM:
		vb.memory = "4096"
		vb.cpus = 2
  	end
end