# LAMP + Java, NodeJS, and MongoDB

The purpose of this project is to have a development environment up and running in the quickest amount of time.

## Dependencies

* Vagrant (1.22+)
* VirtualBox (4.2+)
* Ruby (1.87+)

## Installation

Once all dependencies have been installed, run `./setup.rb` to initialize the vagrant environment.

The script will do the following:

1. Configure your shared directory.
1. Update any attached submodules (cookbooks)
1. Install dependent vagrant plugins.

Then, run `vagrant up`.

## Using the environment

#### Accessing apache locations

In your mapped directory, the project directory must conform to your hostname. On vagrant, if you wanted to access `http://boxmeup.c.dev` from the browser,
then in the vagrant shared directory, the directory structure needs to be: `/home/vagrant/shared/boxmeup/`. This is provided that your configured hostname is `c.dev` in the `config.yml`.
