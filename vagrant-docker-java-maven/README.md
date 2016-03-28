# CentOS 6.5 Automated VM Setup for Docker Containers

## Prerequisites

* Install Virtualbox: https://www.virtualbox.org/wiki/Downloads
* Install Vagrant: https://docs.vagrantup.com/v2/installation/
* Ensure that vagrant executable is on the executable path

## VM Setup (automated)

* Clone this project into the directory above your code project directory requiring Docker 
    * This will include your code project in the shared folder with the VM
    * .gitignore ignores all files not contained in this repo so there is no danger in doing this

`$ cd .. #directory above your code project`
<br>
`$ git init`
<br>
`$ git remote add origin https://github.com/mattcoffey/vagrant-docker.git`
<br>
`$ git fetch`
<br>
`$ git checkout -t origin/master`

* Download VM image (cached after the first time) and boot VM (ensure that you are in the directory with the Vagrantfile first):

`$ vagrant up`

* As part of the VM provisioning, Docker, Java and Maven are installed:
    * `deploy_docker.sh` is run and installs and configures Docker
    * `deploy_mvn.sh` is run and installs Java and Maven

## Check that it worked:

* ssh into VM:

`$ vagrant ssh`

* Check docker:

`$ docker ps -a`

* You should see something like this:

<pre>
  [vagrant@vagrant-centos65 ~]$ docker ps -a 
  CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                     NAMES
</pre>

* Check Java and Maven:
  
`$ java -version`
<br>
`$ mvn -version`
