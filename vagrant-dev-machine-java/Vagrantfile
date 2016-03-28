# VARIABLES / VARIÁVEIS

vm_ip = "192.168.50.6"



# MACHINE / MÁQUINA
Vagrant.configure(2) do |config|

	# OPERATIONAL SYSTEM / SISTEMA OPERACIONAL
	config.vm.box = "centos-7-minimal"
  	config.vm.box_url = "https://atlas.hashicorp.com/relativkreativ/boxes/centos-7-minimal/versions/1.0.3/providers/virtualbox.box"

	# IP CONFIGURATION
	# CONFIGURAÇÃO DE IP NA MÁQUINA
	config.vm.network "private_network", ip: vm_ip


	# "PHYSICAL" CONFIGURATIONS OF MACHINE
	# CONFIGURAÇÕES "FÍSICAS" DA VM
	config.vm.provider "virtualbox" do |vb|
    	#vb.memory = "4096"
    	vb.name = "dev-machine"
  	end

  	# SHELLs
  	config.vm.provision :shell, :path => "provision/before-provision.sh"
  	config.vm.provision :shell, :path => "provision/install-mongodb.sh"
end