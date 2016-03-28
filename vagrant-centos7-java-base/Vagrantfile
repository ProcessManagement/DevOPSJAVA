Vagrant.configure(2) do |config|
  config.vm.box = "umrigark/centos7"
  config.vm.provider "virtualbox" do |v|
  	v.memory = 4096
  	v.cpus = 2
   end

   #Shell provisioning
    config.vm.provision "shell" do |s|
         s.path = "installjava.sh"
    end
	
end
