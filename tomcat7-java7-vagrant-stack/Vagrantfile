# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
aws_config = YAML::load_file("props.yml")

Vagrant.configure("2") do |config|
  config.vm.box = "dummy"
  config.puppet_install.puppet_version ="3.2.1"
  config.vm.provision :puppet
  config.ssh.forward_agent = true
  # provider details
  config.vm.provider :aws do |aws, override|
    aws.access_key_id = aws_config["aws.access_key_id"]
    aws.secret_access_key = aws_config["aws.secret_access_key"]
    aws.keypair_name = aws_config["aws.keypair_name"]
    aws.instance_type = aws_config["aws.instance_type"]
    aws.region = aws_config["aws.region"]
    aws.subnet_id = aws_config["aws.subnet_id"]
    aws.security_groups = aws_config["aws.security_groups"]
    aws.ami = aws_config["aws.ami"]
    override.ssh.username = aws_config["override.ssh.username"]
    override.ssh.private_key_path = aws_config["override.ssh.private_key_path"]
  end
  # provider details
  config.vm.define "web" do |web|
    web.vm.host_name = "web"
    web.vm.provider :aws do |aws|
        aws.tags = { Name: "charu web"  }
    end
    web.vm.synced_folder 'puppet/modules/tomcat7/files', '/workspace', type: "rsync"
    web.vm.provision "puppet" do |puppet|
      # puppet details
      puppet.manifests_path = "puppet"
      puppet.manifest_file = "default.pp"
      puppet.module_path = "puppet/modules"
      puppet.options = "--verbose --debug"
      # puppet details
     end
  end
end