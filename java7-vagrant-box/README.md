# A Java Vagrant Box

This is a Vagrant configuration for a Java 7 box with essential tools.
The operating system is a Ubuntu Quantal cloud `i386` image.

## Requirements

Obviously... [Vagrant](http://www.vagrantup.com/) and [Oracle VirtualBox](https://www.virtualbox.org/).

You will need the awesome [Fabric](http://fabfile.org) and 
[Fabtools](http://fabtools.readthedocs.org) to provision the box:

    pip install fabric
    pip install fabtools

## Running the box

You can start the box using the usual Vagrant `up` command:

    vagrant up

The next steps are obviously to provision it with Fabric, then log in:

    fab vagrant provision
    vagrant ssh

### Glassfish support

The box can be provisioned with [Glassfish](http://glassfish.org/):

    fab vagrant provision_glassfish

Glassfish is installed in `~/glassfish3` with the following configuration:

- admin user: `admin`
- admin password: `adminadmin`
- access to the HTTP interface from the host on port `18080`
- access to the HTTP admin console from the host on port `14848`

## License

Copyright (C) 2013 Julien Ponge.

Files and code are being made available under the terms of the following license agreement.

               DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                       Version 2, December 2004

    Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

    Everyone is permitted to copy and distribute verbatim or modified
    copies of this license document, and changing it is allowed as long
    as the name is changed.

               DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
      TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

     0. You just DO WHAT THE FUCK YOU WANT TO.
