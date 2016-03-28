Sample Java Project with Chef
=============================

This is a sample to show how Chef can be used to configure a Java environment.

The Vagrantfile can be used to provision the Java application on a
virtual machine managed by Virtual Box. See http://vagrantup.com/
. To see the application running just use:
vagrant up

Another possibility is to provision the application using chef
solo. The script install.sh does that.

The web application is located in cookbooks/webapp/files/default .

Look at roles/tomcatserver.json to figure out which recipes are run
and how they are customized. The cookbooks are taken from the
Opscode's Open Source repository.

The directory .chef contains a simple knife.rb that must be adjusted
to be used with knife.

To use it:
* Install Knife - see http://docs.opscode.com/install_workstation.html
* Install the EC2 plug in - see dazu
  http://docs.opscode.com/plugin_knife_ec2.html
* Upload the cookbooks using  `knife cookbook upload –a`
* Upload the role with `knife role from file roles/tomcatserver.json`
* Now create a new server with   `knife ec2 server create -r
  'role[tomcatserver]' -i .chef/AmazonPEM.pem -r 'role[tomcatserver]'`
