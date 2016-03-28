# vagrant-javabox

1. Install Vagrant on your Host.
2. Install VirtualBox on your Host.
3. Make sure you have a Box installed "vagrant box add ubuntu/trusty64"
4. Clone this repository in your workspace.
5. Within your workspace change to the new folder vagrant-javabox (this project)
6. In your workspace "vagrant up"
7. After the provisioning is complete it's a good idea to restart the box with "vagrant halt;vagrant up"
8. Login to your box with "vagrant ssh" or use your favorite ssh client. 

The Linux Host Box will be provisioned as described in provision.sh.  It's a bit on the heavy side but should create a consistant setup every time.

We load IntelliJ IDEA Community Edition by default.  If you want Eclipse look at the 'run' function in provision.sh


    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key

