#!/bin/bash

JAVA_VERSION=jdk1.7.0_51
JAVA_ARCHIVE=${JAVA_VERSION}-linux-x64.gz

MAVEN_VERSION=3.0.5
MAVEN_URL=http://mirror.olnevhost.net/pub/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz

# basic stuff we need.
yum install -y wget git-core


if [ -e "/vagrant/fortify-distro" ] ; then 
	echo installing fortify
	(cd /vagrant/fortify-distro  ; ./HP_Fortify_SCA_and_Apps_4.00_linux_x64.run --mode unattended )
else
	echo skipping fortify install
fi


exit 0


echo installing and configuring java
#
FILE=/vagrant/resources/$JAVA_ARCHIVE
tar -xzf $FILE -C /usr/local
ln -s /usr/local/${JAVA_VERSION} /usr/local/java
ln -s /usr/local/java/bin/java /usr/bin/java
#
echo export JAVA_HOME=/usr/local/java >> /etc/profile.d/java.sh
echo export PATH=\${JAVA_HOME}/bin:\${PATH} >> /etc/profile.d/java.sh



echo installing and configuring maven
#
wget ${MAVEN_URL}
tar xvf apache-maven-${MAVEN_VERSION}-bin.tar.gz
mv apache-maven-${MAVEN_VERSION}  /usr/local/apache-maven
ln -s /usr/local/apache-maven-${MAVEN_VERSION} /usr/local/apache-maven

cat > /etc/profile.d/maven.sh   <<MVN_CONFIG
export M2_HOME=/usr/local/apache-maven
export M2=\$M2_HOME/bin 
export PATH=\$M2:$PATH
MVN_CONFIG


echo installing jenkins
#
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
yum install -y jenkins
( cd /usr/lib/jenkins ; mkdir -p unpacked ; cd unpacked ; unzip ../jenkins.war) 
JENKINS_CLI=/usr/lib/jenkins/unpacked/WEB-INF/jenkins-cli.jar


service jenkins start
chkconfig jenkins on






