#!/bin/bash

### Eclim Install ###################################################################################
ECLIPSE_URL=http://developer.eclipsesource.com/technology/epp/mars
ECLIPSE_TAR_BALL=eclipse-java-mars-1-linux-gtk-x86_64.tar.gz
ECLIPSE_DIR=eclipse
ECLIM_URL=http://sourceforge.net/projects/eclim/files/eclim/2.5.0
ECLIM_JAR=eclim_2.5.0.jar

wget -nv $ECLIPSE_URL/$ECLIPSE_TAR_BALL
tar -zxf $ECLIPSE_TAR_BALL $ECLIPSE_DIR
rm $ECLIPSE_TAR_BALL

cp /vagrant/.eclimrc ~/

wget -nv $ECLIM_URL/$ECLIM_JAR
java -Dvim.files=$HOME/.vim -Declipse.home=$HOME/$ECLIPSE_DIR -jar $ECLIM_JAR install
rm ECLIM_JAR

### VIM ############################################################################################
mkdir -p ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
cp /vagrant/.vimrc ~/

### .bashrc ########################################################################################
echo "export TERM=xterm-256color" >> ~/.bashrc
