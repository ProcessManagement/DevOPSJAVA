jenkins-build-box-with-vagrant
==============================

This project provides Vagrant recipe for provisioning linux box with  jenkins,java,maven and optionally, fortify.

A jdk must be downloaded from Oracle and copied to the resources directory (which will be mounted as /vagrant/resources when the project is being built.)
Next, make sure you update the JDK version number in the script. The version of maven that is pullled down may be similarly configured.

If you are installing fortify, then create add a fortify-distro directory and setup fortify for a non-interactive install.


