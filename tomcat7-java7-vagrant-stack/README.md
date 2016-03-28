#### tomcat7-java7-vagrant-stack
### A single Ubuntu 14 VM on AWS provisioned using Vagrant, Puppet to host & run Java7,Tomcat7 & Mysql5

#### Purpose

If you need a ready java web app dev stack quickly, clone this repo, setup the conf files, do a "vagrant up".
You will have a running dev/test environment on AWS.

#### Prerequisite

AWS account : 
  * access and secret key
  * .pem or .ppk SSH key to access your AWS servers(you can create one on AWS)

#### How to setup...details

###### AWS

- Signup at http://aws.amazon.com/console/.
- create a Ubuntu 14 based dev box.
    - create keypair, sec group, note down the subnet and other details.


###### Vagrant

- SSH into the Ubuntu dev box, run the foll

```
sudo apt-get update
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb
sudo dpkg -i vag*.deb
sudo apt-get install make
sudo apt-get install git
sudo apt-get install gcc
```
- Setup AWS box for Vagrant
  - Refer https://github.com/mitchellh/vagrant-aws
```
vagrant plugin install vagrant-aws
vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
```

###### This stack 

- clone this repo and setup the config file

```
git clone --recursive https://github.com/charudath/tomcat7-java7-vagrant-stack
cd tomcat7-java7-vagrant-stack/
cp yourcert.pem . (copy your AWS SSH key here, MAKE SURE chmod 400 for pem !)
vi props.yml (update as below)
vagrant up
```

```
aws.access_key_id : "your API key"
aws.secret_access_key : "your API secret"
aws.keypair_name : "you keypair name as created in AWS"
aws.instance_type : "m3.large"
aws.ami : "ami-487a3920"
aws.region : "us-east-1"
aws.subnet_id : "an accessible subnet"
aws.security_groups : "you security group id as created in AWS"
override.ssh.username : "ubuntu"
override.ssh.private_key_path : "yourSSHKey.pem"
```


#### How to extend

###### Background
The project root has the ssh key, props.yml and Vagrantfile.

it also has a manifests folder containing a default.pp puppet file.
This is not used, but vagrant complains if its not there. so just ignore this file.

The main config for Vagrant+Puppet are the foll lines:
```
puppet.manifests_path = "puppet"
puppet.manifest_file = "default.pp"
puppet.module_path = "puppet/modules"
```
They correspond to 
-	.(root)
	-	Vagrantfile
	-	props.yml
	-	ssh.pem
	-	*puppet*
		-	*default.pp*	
		-	*modules*
			-	java7
				-	manifests
					-	init.pp
			-	someOtherModule



Some hard rules :
 1. Vagrant needs a manifests/default.pp in the root folder (in the same folder as Vagrantfile) even if you have configured it to work differently.
 2. The configured default.pp using `puppet.manifest_file` should be at the same level as the modules folder configured thro `puppet.module_path`.
 3. Each module MUST have `init.pp` as the initial puppet manifest.
  
 
###### Your changes
- to change the vagrant provider, update the top section of the Vagrantfile marked as `# provider details`
- to update puppet config details , update the Vagrantfile at `# puppet details`
- to change the java, tomcat installation details ; look into the respective `init.pp` files under `puppet/modules` folder
- to choose what gets installed , update the `puppet/default.pp` file
- the mysql is a puppet forge submodule, to understand it more look into https://github.com/puppetlabs/puppetlabs-mysql




