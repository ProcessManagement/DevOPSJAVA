# vagrant-ubuntu-java-docker
Ubuntu 14.04 vagrant base box with current Docker + Java 8

# Usage
```
./make_box.sh
```
This will use the ubuntu/trusty64 base box, run the [bootstrap shell script](bootstrap/bootstrap.sh) and provision a current Docker engine, along with docker-compose and a recent Java 8 installation and finally do some tricks, to reduce the image size.

A resulting **ubuntu-java-docker.box** will be created; use this as you wish...

# Troubleshooting
As the base box is 40G and the free space gets cleared by writing /dev/null to the disk, you need +40G free space and a fast disk, otherwise it might take some time... (i.e. an hour).

Sometimes the Oracle download site for Java is verrrrrrrrry slow, retry at a later time (actually this was the motivation for building this base box in the beginning)!

A lot of stuff is fetched from the internet (~1G on first run), so you should have a decent (i.e. fast) connection.

Some magic is required to re-enable the VirtualBox Guest additions after Docker has been installed, an error message about failed mount is expected behaviour - do not worry!

# Security
Provisioning is done with the [bootstrap shell script](bootstrap/bootstrap.sh), have a look at it when in doubt. Your personal vagrant ssh key will be embedded into the base box, however a recent Vagrant fixes this issues upon first start.

# TODO
* make docker-compose version configurable
* convert to packer.io goodness
* optimize image size

PRs are welcome!