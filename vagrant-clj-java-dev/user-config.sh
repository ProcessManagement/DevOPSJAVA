#!/bin/bash
# Set up an emacs+EVIL Clojure dev environment for the 'vagrant' user.

git clone https://github.com/moquist/dotfiles.pub
mv ~/dotfiles.pub ~/.dotfiles.pub
bash ~/.dotfiles.pub/bin.pub/dotfiles.pub-set-up

# Keep this step last, so the user in the guest GUI has a clear indication when
# provisioning is complete.
rsync -av /vagrant/desktop-contents/ ~vagrant/Desktop/
