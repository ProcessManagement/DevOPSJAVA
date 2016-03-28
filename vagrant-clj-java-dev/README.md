# vagrant-clj-java-dev

## Dependencies

1. [vagrant](http://vagrantup.com)
1. [virtualbox](http://virtualbox.com)

This has been tested with a Linux host. Theoretically, it should work in
Windows. Please let me know!

## Usage

1. clone this repo
1. ```cd``` into the repo directory
1. ```vagrant up```
1. Wait for a while. First, vagrant will download a 1.4G image from the
   Internet, and then import it, etc.
1. After the GUI starts, keep in mind that *the provisioning isn't done yet*. If
   you take a look at the command line where you ran ```vagrant up```, you'll
   see that even though the GUI is running, vagrant is still provisioning the
   system. You can sign in right now if you want, but remember that **it's not
   done yet**! :)
   1. Signing in early doesn't hurt anything. It just means packages aren't
      installed yet. When you see README file(s) and a Terminal launcher appear
      on the desktop, you'll know provisioning is done.
1. Log in with vagrant / vagrant.
1. Once provisioning is done, you'll see one or more README files on the
   desktop, along with a Terminal launcher in case you need it.
1. Read a README if necessary to learn about the configuration, and have fun
   developing!
