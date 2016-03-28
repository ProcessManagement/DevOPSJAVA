#!/usr/bin/env bash

sudo sh -c 'echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list'
sudo sh -c 'echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886

sudo apt-get update

sudo sh -c 'echo oracle-java9-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections'
sudo apt-get -y install oracle-java9-installer
sudo apt-get -y install oracle-java9-set-default

sudo apt-get -y install maven
sudo apt-get -y install git
sudo apt-get -y install mercurial

mkdir build && cd build
git clone git://github.com/jline/jline2.git && cd jline2

# Java 9 does not support source/target < 1.6
sed -i 's/<maven\.compiler\.source>1.5<\/maven\.compiler\.source>/<maven\.compiler\.source>1.6<\/maven\.compiler\.source>/g' pom.xml
sed -i 's/<maven\.compiler\.target>1.5<\/maven\.compiler\.target>/<maven\.compiler\.target>1.6<\/maven\.compiler\.target>/g' pom.xml

echo "***************************************************************"
echo "*                                                             *"
echo "* Building jline2                                             *"
echo "*                                                             *"
echo "***************************************************************"

mvn install -Dmaven.test.skip

cd ..
hg clone http://hg.openjdk.java.net/kulla/dev kulla && cd kulla

echo "***************************************************************"
echo "*                                                             *"
echo "* Fetching source. Sit back, this might take a few minutes... *"
echo "*                                                             *"
echo "***************************************************************"

sh get_source.sh 

cd langtools/repl/

export JLINE2LIB=`find ${HOME}/build/jline2/target -name jline*-SNAPSHOT.jar`
mkdir -p build

javac -Xlint:unchecked -Xdiags:verbose -cp ${JLINE2LIB} -d build `find ../src/jdk.jshell/share/classes/ -name '*.java'`

echo "export JLINE2LIB=`find ${HOME}/build/jline2/target -name jline*-SNAPSHOT.jar`" >> ~/.bashrc
echo "alias jshell='java -ea -esa -cp ${JLINE2LIB} -cp build/kulla/langtools/repl/build jdk.internal.jshell.tool.JShellTool \"$@\"'" >> ~/.bashrc
