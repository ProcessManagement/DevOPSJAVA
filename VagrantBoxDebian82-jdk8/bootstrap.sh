#!/bin/bash

#echo 'setxkbmap -layout de ' >> ~vagrant/.profile # set german keyboard layout for PC
#echo 'setxkbmap -layout de ' >> ~vagrant/.bashrc # set german keyboard layout for  PC
echo 'setxkbmap -layout de -variant mac' >> ~vagrant/.profile # set german keyboard layout for mac
echo 'setxkbmap -layout de  -variant mac' >> ~vagrant/.bashrc # setx german keyboard layout for mac

# improve proxy settings for vagrant proxy plugin
echo "source /etc/profile.d/proxy.sh" >> ~vagrant/.bashrc
cp /vagrant/set-gnome-proxy.sh  ~vagrant/.set-gnome-proxy.sh
echo "sh ./.set-gnome-proxy.sh" >> ~/.profile


# allow sudo for user vagrant
#echo 'vagrant    ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
#usermod -G admin vagrant
groupadd vboxfs
usermod -a -G vboxfs vagrant

apt-get update
apt-get install -y mate-desktop-environment lightdm build-essential mate-terminal \
  apt-transport-https software-properties-common wget apt-cacher-ng libsdl1.2debian \
  python-software-properties debconf-utils git git-core zlib1g-dev postgresql libpq-dev \
  zip sqlite3 libsqlite3-dev pgadmin3 libnss3 xdg-utils iceweasel

export KERNELVERSION=`uname -r`
apt-get install -y linux-headers-$KERNELVERSION

# update guest additions do 5.0.14
cd /tmp
wget http://download.virtualbox.org/virtualbox/5.0.14/VBoxGuestAdditions_5.0.14.iso
mount ./VBoxGuestAdditions_5.0.14.iso /mnt
/mnt/VBoxLinuxAdditions.run
umount /mnt


## make partition for docker if it does not already exist
# docker_disk_is_formatted=`blkid /dev/sdb1`
# if [ -z "$docker_disk_is_formatted" ]; then
#  # make partition
#   cat <<EOF | fdisk /dev/sdb
# n
# p
# 1
#
#
# w
# EOF
#   # format partition
#   mkfs.ext4 /dev/sdb1
#   # automount partition on boot
#   mkdir -p /var/lib/docker
#   echo '/dev/sdb1    /var/lib/docker    ext4    defaults            1     2' >> /etc/fstab
# fi
# mount -a

# install software


# install jdk 8
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
apt-get install --yes --force-yes oracle-java8-installer

# install chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
apt-get update
apt-get install -y google-chrome-stable nodejs npm

# install docker

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install --yes --force-yes -f docker-engine
curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
usermod -a -G docker vagrant

# install atom & set proxy for atom
wget https://github.com/atom/atom/releases/download/v1.4.0/atom-amd64.deb
dpkg -i atom-amd64.deb
if [ -n "$http_proxy" ]; then
  mkdir -p ~vagrant/.atom
  cat << EOF > ~vagrant/.atom/.apmrc
; settings for proxy
https-proxy = ${https_proxy}
http-proxy = ${http_proxy}
EOF
fi

# install rvm + ruby
curl -L https://get.rvm.io > /tmp/rvm-install.sh
su - vagrant -c  'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
sudo -u vagrant -H sh -c 'bash /tmp/rvm-install.sh'
su - vagrant -c 'rvm install 2.2.2'
echo 'export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting' >> ~vagrant/.bashrc
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*' >> ~vagrant/.bashrc

# vagrant proxy plugin settings
# sed -i "s/#includedir \/etc\/sudoers.d/includedir \/etc\/sudoers.d/" /etc/sudoers


# enable autologin for user vagrant
echo '[SeatDefaults]' > /etc/lightdm/lightdm.conf
echo 'autologin-user=vagrant' >> /etc/lightdm/lightdm.conf

if [ -f "/vagrant/copy-settings.sh" ]; then
   /vagrant/copy-settings.sh
fi

# install some fonts
cd /tmp
wget http://ftp.de.debian.org/debian/pool/main/f/fonts-liberation/fonts-liberation_1.07.4-1_all.deb
dpkg -i fonts-liberation_1.07.4-1_all.deb

# install smartgit
cd /tmp
wget http://www.syntevo.com/downloads/smartgit/smartgit-generic-7_0_5.tar.gz
cd /usr/local
tar xzvf /tmp/smartgit-generic-7_0_5.tar.gz
echo "export PATH=\$PATH:/usr/local/smartgit/bin" >> ~vagrant/.bashrc


# cleanup
rm /tmp/rvm-install.sh
rm /tmp/*.deb /tmp/*.iso
chown -R vagrant ~vagrant
