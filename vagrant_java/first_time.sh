#!/bin/sh

vagrant plugin install vagrant-omnibus
vagrant plugin install vagrant-vbguest

vagrant up --provision
vagrant halt
vagrant up --provision

