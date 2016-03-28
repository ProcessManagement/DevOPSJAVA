REM Windows shell script to initialize base box
REM not sure how/if this runs as PowerShell

vagrant destroy base -f
del package.box
del shared\keys\*   # re-set public/private keys
vagrant box add http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box --name opscode/temp --force
vagrant up base
vagrant package base
vagrant box add opscode-ubuntu-14.04a package.box -f
del package.box
vagrant destroy base -f