Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"

  config.vm.provider "virtualbox" do |v|
    v.name = "Java9 Test Box"
    v.memory = "2048"
  end

  config.vm.provision :shell, path: "provisioning/bootstrap.sh", privileged: false
end
