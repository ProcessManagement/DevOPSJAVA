#!/bin/bash 
 
 # install eclipse
 # see also https://github.com/fgrehm/docker-eclipse

echo "Download Eclipse from the eclipse web page and name it 'eclipse.tar.gz'."
# wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/luna/SR2-RC3/eclipse-java-luna-SR2-RC3-linux-gtk-x86_64.tar.gz -O /home/ralf/bin/eclipse.tar.gz -q 

echo 'Installing eclipse' 
tar -xf eclipse.tar.gz -C /opt 
ln -s /opt/eclipse/eclipse /usr/local/bin/eclipse
cp eclipse.desktop  /usr/share/applications/eclipse.desktop



 
