#!/bin/bash

### Java Install ###################################################################################
JDK_URL=http://download.oracle.com/otn-pub/java/jdk/8u60-b27
JDK_TAR_BALL=jdk-8u60-linux-x64.tar.gz
JDK_DIR=jdk1.8.0_60

wget -nv --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_URL/$JDK_TAR_BALL
tar zxf $JDK_TAR_BALL $JDK_DIR
mv $JDK_DIR /usr/local/
ln -s /usr/local/$JDK_DIR/bin/java /usr/bin/java
ln -s /usr/local/$JDK_DIR/bin/javac /usr/bin/javac
rm $JDK_TAR_BALL

### Maven Install ##################################################################################
MVN_URL=http://ftp.jaist.ac.jp/pub/apache/maven/maven-3/3.3.3/binaries
MVN_TAR_BALL=apache-maven-3.3.3-bin.tar.gz
MVN_DIR=apache-maven-3.3.3

wget -nv $MVN_URL/$MVN_TAR_BALL
tar -zxf $MVN_TAR_BALL $MVN_DIR
mv $MVN_DIR /usr/local
ln -s /usr/local/$MVN_DIR/bin/mvn /usr/bin/mvn
ln -s /usr/local/$MVN_DIR/bin/mvnDebug /usr/bin/mvnDebug
rm $MVN_TAR_BALL

### VIM Install ####################################################################################
apt-get install -y git
apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev ruby-dev mercurial
apt-get install -y liblua5.2-dev lua5.2
apt-get remove -y vim vim-runtime gvim

git clone https://github.com/vim/vim.git
cd vim/src

./configure \
--with-features=huge \
--enable-multibyte \
--enable-rubyinterp \
--enable-pythoninterp \
--with-python-config-dir=/usr/lib/python2.7/config \
--enable-perlinterp \
--enable-luainterp \
--enable-gui=gtk2 \
--enable-cscope \
--prefix=/usr
make
sudo make install

### Xvfb Install ###################################################################################
apt-get install -y xvfb
