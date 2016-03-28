# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$provision_script = <<SCRIPT
echo "provisioning system ..."
echo "updating system packages ..."
apt-get update
# use this function for non-interactive apt-get upgrade, dist-upgrade, and install
apt_get_yes () {
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" "$@"
}
apt_get_yes upgrade
apt_get_yes dist-upgrade
echo "installing new packages..."
apt_get_yes install vim
apt_get_yes install openjdk-7-jre
apt_get_yes install openjdk-7-jdk
# get 'add-apt-repository' command
apt_get_yes install software-properties-common
# add ppa for gradle
add-apt-repository -y ppa:cwchien/gradle
apt-get update
apt_get_yes install gradle-ppa
apt_get_yes install git
apt_get_yes install curl
apt-get autoremove
apt-get clean
#echo "disable selinux and iptables"
#sed -i s/SELINUX=permissive/SELINUX=disabled/g /etc/selinux/config
#chkconfig --level 0123456 iptables off
echo "setting up app script and init script ..."
USER=vagrant
APP=java-app-dev
APP_DIR=/usr/share/${APP}
SCRIPT=${APP_DIR}/${APP}.sh
UPSTART=/etc/init/${APP}.conf
LOG=/var/log/${APP}
CONF_DIR=/vagrant
CONF=${CONF_DIR}/${APP}.conf
# setup app script
mkdir ${APP_DIR}
chown ${USER}:${USER} ${APP_DIR}
cat << EOF > ${SCRIPT}
\#!/bin/bash
stop() {
    echo "stopping java app ..."
}
trap stop TERM
if [ -r ${CONF} ]; then
    . ${CONF}
else
    echo "fatal error: missing ${CONF}"
    exit 1
fi
cd ${APP_DIR}
if [ ! -d "\\${GIT_PROJ_NAME}" ]; then
    git clone "\\${GIT_CLONE_URL}" "\\${GIT_PROJ_NAME}"
fi
if [ ! -d "\\${GIT_PROJ_NAME}" ]; then
    echo "fatal error: java app directory \\${GIT_PROJ_NAME} was not created"
    exit 1
fi
cd "\\${GIT_PROJ_NAME}"
git pull
./gradlew clean run
EOF
chmod 755 ${SCRIPT}
chown ${USER}:${USER} ${SCRIPT}
# setup upstart script
cat << EOF > ${UPSTART}
description     "Run java-app-dev"

\# Vagrant emits 'vagrant-mounted' signal after mounting synced folder. Start
\# after this signal instead of starting on a runlevel otherwise conf file
\# needed by java-app-dev script won't be available.
start on vagrant-mounted
stop on runlevel [!2345]

respawn

script
    su -c "${SCRIPT}" ${USER} > ${LOG}
end script
EOF
echo "provisioning complete"
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "chef/ubuntu-14.04"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 8080, host: 8080, protocol: 'tcp'

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

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  config.vm.provision "shell", inline: $provision_script
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
  #
  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision "chef_solo" do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { mysql_password: "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision "chef_client" do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
