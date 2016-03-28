  rudolf_dev
==========

RudolF open source development environment for collaborators.

This is a Vagrant vm setup which automatically sets up a vm with
java and a running mysql instance, on a 64 bit ubuntu box.  

- Clojure

- Java 6 or 7

- Python

- Mysql client + server, running on startup

- Thrift (7+)

- VowpallWabbit 

Background
==========

A few weeks ago I had to buy a new laptop, and spend 3 days installing new versions of g++, java, thrift, etc... I found that things didn't work the same on my new operating system (OS X Lion) as they did on Snow Leopard.  In fact, I found that some libraries would not compile at all !   I tried everything : macports, homebrew, and even hand compiling c libraries, to get certain dependencies resolved.  And then I realized that, simply put : nothing beats linux for a development environment. 

That said : Nothing beats a mac for working, coding, and communicating with others.  So rather than have to non ideal machines (a linux box and a mac book), I took a cue from Daniel Knell, and learned about Vagrant. 

However, the mess of maintaining shell scripts or puppet scripts for provisioning boxes across different machines still remained.  Enter version control.

With git, vagrant, and virtual box, we can now have a version controlled development environment that can be brought up and torn down from scratch.

Who This Project is For
=======================
Any Java or Clojure developer who would rather spend their time writing excellent code and testing out new technologies rather than troubleshooting their own computers all day long.  This is especially directed at Mac developers who don't want to spend their time keeping up with the latest XCode installations and libraries.  


Why This Project Exists 
=======================

Development is often hindered by configuration issues.  These come in many shapes and sizes, either : 

- Developers can't build their code locally due to mismatched compilers/environments.
- Developer CAN build code locally, but it runs differently than server environments.

Of course, Virtual machines provide an answer to this - but they are : 

- Difficult to download.
- Often require lots of customizations after setup, which can take (literally) several days.


How YOU should use this VM (and more importantly : HOW YOU CAN HELP ! )
=======================================================================

Vagrant is super easy to set up, so I won't describe it here.  First - just set it up - and contact me if you have issues, jayunit100 at gmail.  Once running, start developing.  Consider forking it and creating your own version by editing the .sh provisioner, and telling me about it! I would love to 
have new versions with better optimizations, and potentially more (or better) libraries.   Here is the way I deploy it : 

- Add a development directory ~/Development to vagrant (see the Vagrantfile for the default, that reflects my own practices). 
- Don't install git in vagrant.  Rather, I do all my git/code editing and pushing pulling in my local machine. 
- Use vagrant only to build and test your code, in the ideal environment.  I use the OS for everything else. 
- Don't bother turning your pristine host into a mess of gcc, java, python, clojure, fortran, or whatever libraries.  Just use the VM for all that - by editing the shell script as necessary.




Languages this Environment is Designed to Support
=================================================

- Clojure
- Java 6 or 7
- Python
- Mysql client + server, running on startup
- Thrift (7+)
- VowpallWabbit 

SUMMARY OF BOXES
================

There are several boxes, and we intend to build new ones on a regular basis reflecting improvements and updates in Ubuntu, Java, Clojure, MySQL, VowpallWabbit, etc... But there will be some bias in the exact versions libraries on these boxes.  If your a new XXXXXXXX developer, just trying to get started (For example, with Java and Clojure, or you just want a simple working MySQL install), these boxes are IDEAL.  If you have a very specific environment, then I suggest you customize the rudolf.sh to suit your needs (and share them with me - if you get a chance).

In general, the higher "version", the more up to date the OS and libraries will be.  For example, v1 is Ubuntu 10.01, and v2 is Ubuntu 12, etc... 


v2 
==
I built this box to test out some JDK build errors that were stochastic.  By upgrading v1/ to v2/, I found that some file lock jvm errors magically disappeared.  NOTE : For better performance with large java builds - you can add this to your /etc/security/limits.conf file.

    vagrant  hard nofile 65535

    vagrant  soft nofile 65535

v1 
==
<<<<<<< HEAD
=======

>>>>>>> 758c6e8be5ff4bc8f092ea18c74a29b4a4ecfda8
This box is lucid64 bit.  It has openjdk6, clojure, thrift, vw6, mysql (client+server, ready to use) right out of the box.


Instructions
============

0. Clone this project, cd to it. And cd to a version (preferabbly the latest).

1. Install vagrant / virtual box.

2. do:

    vagrant up
    
This will take a while. 

3. do:

    $ vagrant ssh
    
and try to run some commands :

    $ java -version

    $ mysql --user=root

4. Note that your /vagrant (in the launched box) points to your local directory, and thus, 
you can use this box for MULTIPLE projects, simply by launching vagrant up in a different directory.  Alternatively, you can make this 
your development root - so that your vagrant box "sees" all projects.  
