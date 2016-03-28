#!/bin/bash
sudo su - root
sudo yum install -y  wget docker
USER_DIR=/root
JAVA_RELEASE=7u80
JAVA_RELEASE_WITH_BUILD_NO=7u80-b15
JAVA_DOWNLOAD_URL=http://download.oracle.com/otn-pub/java/jdk/$JAVA_RELEASE_WITH_BUILD_NO/jdk-$JAVA_RELEASE-linux-x64.tar.gz
MAVEN_MAJOR_VERSION=3
MAVEN_VERSION=3.3.3
MAVEN_DOWNLOAD_URL=ftp://mirror.reverse.net/pub/apache/maven/maven-$MAVEN_MAJOR_VERSION/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
 
J_HOME=/usr/local/java
M_HOME=/usr/local/maven
 
mkdir -p $J_HOME
mkdir -p $M_HOME
 
cd $J_HOME && wget --quiet --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "$JAVA_DOWNLOAD_URL" -O - | tar -xz --strip-components=1
 
cd $M_HOME && wget --quiet "$MAVEN_DOWNLOAD_URL" -O - | tar -xz --strip-components=1
 
echo -e "\n\n #Setting up JAVA_HOME and PATH for Oracle JAVA 1.7 \n JAVA_HOME=$J_HOME \n export JAVA_HOME \n export PATH=\$JAVA_HOME/bin:\$PATH" >> $USER_DIR/.bashrc
 
echo -e "\n\n #Setting up MAVEN_HOME and PATH \n MAVEN_HOME=$M_HOME \n export MAVEN_HOME \n export PATH=\$MAVEN_HOME/bin:\$PATH" >> $USER_DIR/.bashrc
 
bash && cd $USER_DIR
