#!/bin/bash

#
#  This script will provision a box for Open Retail development
#

set -e # We exit on any errors! 

VAGRANT_DIR=/vagrant/
HOME_DIR=~/
BIN_DIR=${HOME_DIR}bin/
DOWNLOAD_DIR=${VAGRANT_DIR}download/
ORACLE_PPA_INSTALL=true

installPackage() {
  local packages=$*
  echo "Installing $packages"
  sudo apt-get install -y $packages >/dev/null 2>&1
}

#
# download url file
#
download() {
  local url=$1$2
  local file=$2
  local downloadFile=${DOWNLOAD_DIR}${file}

  if [ ! -e "$downloadFile" ]
  then
    echo "Downloading ${url} to ${downloadFile}"
    wget -P ${DOWNLOAD_DIR} -q --progress=bar "${url}"
    echo "Download complete"
  else
    echo "Download skipped for cached file ${downloadFile}" 
  fi
}

installPackages() {
  echo "Begin Install packages"

  if [ "$ORACLE_PPA_INSTALL" = true ] 
  then
    sudo add-apt-repository -y ppa:webupd8team/java
    echo debconf shared/accepted-oracle-license-v1-1 select true | \
    sudo debconf-set-selections
  
    echo debconf shared/accepted-oracle-license-v1-1 seen true | \
    sudo debconf-set-selections
    echo 'apt-get update'
    sudo apt-get update >/dev/null 2>&1
    installPackage oracle-java6-installer
    # Need at least a base java greater than java6 for maven
    installPackage oracle-java8-installer
  else
    echo 'apt-get update'
    sudo apt-get update >/dev/null 2>&1
    # Need at least a base java greater than java6 for maven
    echo "Processing default JDK"
    installPackage openjdk-7-jdk
  fi
  
  # These are required but not really version specific
  echo "Processing VCS packages"
  installPackage subversion cvs git
  
    # we should read a list of user defined packages too!
  installPackage jed vim mc expect
}

createDirs()
{
  echo 'Creating directories'
  mkdir -p ${BIN_DIR}
  mkdir -p ${DOWNLOAD_DIR}
  mkdir -p ${HOME_DIR}.m2
}

extract() {
  local file=$1
  echo "Extracting ${file}"
  tarCmd="tar -zxvf ${file} -C ${BIN_DIR}"
  echo "Command:${tarCmd}"
  ${tarCmd} >/dev/null 2>&1
  echo "Extract complete"
}

installJdks() {
  
  if [ "$ORACLE_PPA_INSTALL" = false ] 
  then
    echo "Installing Oracle Standard JDK(s)"
    file=jdk1.6.0_41.tgz
    url="http://156.24.34.140/release/java/"
    download ${url} ${file}
    extract ${DOWNLOAD_DIR}${file}
    echo "Install JDK(s) done!"
  fi
  
  
}

installIbmJdk() {

  file=ibm-java-x86_64-sdk-6.0.14.0.bin;
  #file=ibm-java-jre-6.0-9.1-linux-i386.tgz
  echo "Installing IBM JDK ${file}"
  downloadFile=${DOWNLOAD_DIR}${file};
  download http://156.24.31.131/download/ ${file}
  chmod +x ${downloadFile}
  sudo ln -sf /lib/x86_64-linux-gnu/libc.so.6 /lib/
  echo "Running IBM setup ${downloadFile} silently"
  set +e
  sudo ${downloadFile} -i silent
  set -e
  #extract ${downloadFile}
  echo "Install IBM JDK done!"
}

installNodeJs() {
    echo 'Installing NodeJs'
    curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
    installPackage nodejs
    #sudo ln -s /usr/bin/nodejs /usr/bin/node

    echo "Install grunt"
    sudo /usr/bin/npm install -g grunt-cli
    echo "Install bower"
    sudo /usr/bin/npm install -g bower
    echo "Install rimraf"
    sudo /usr/bin/npm install -g rimraf
}

installEnvManagers()
{
  echo 'Installing environment managers (for Java and node.js) '
  echo 'Installing jenv'
  if [ ! -e ~/.jenv ] 
  then
    echo 'Clonning from github to ~/.jenv'
    git clone https://github.com/gcuisinier/jenv.git ~/.jenv >/dev/null 2>&1
  fi
  echo "Setting environment variables"
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
  echo 'Make build tools jenv aware'
  message="jenv enable-plugin ant"
  echo "$message"
  message="jenv enable-plugin maven"
  echo "$message"
  message="jenv enable-plugin gradle"
  echo "$message"
  message="jenv enable-plugin sbt"
  echo "$message"

  echo 'Installing nodenv'
  if [ ! -e ~/.nodenv ] 
  then
    echo 'Clonning from github to ~/.nodenv'
    git clone https://github.com/OiNutter/nodenv.git ~/.nodenv >/dev/null 2>&1
  fi
  if [ ! -e ~/.nodenv/plugins/node-build ] 
  then
    echo 'Installing plugins that provide nodenv install'
    git clone https://github.com/OiNutter/node-build.git ~/.nodenv/plugins/node-build >/dev/null 2>&1
  fi
  echo "Setting environment variables"
  export PATH="$HOME/.nodenv/bin:$PATH"
  eval "$(nodenv init -)"

}

updateBashrc() {
  echo 'Updating .bashrc'
  backupFile=${HOME_DIR}bashrc.vagrant-javabox
  if [ ! -e  $backupFile ]
  then
    cp ${HOME_DIR}.bashrc ${backupFile}
  fi
  cp ${backupFile} ${HOME_DIR}.bashrc # always start from original backup
  cat ${VAGRANT_DIR}bashrc.template >> ${HOME_DIR}.bashrc
  source ${HOME_DIR}.bashrc
}

installRuntimes() {
  set +e
  echo "Install runtimes using environment managers"
  echo "Install java from ${BIN_DIR}"

  for jdk in $(ls ${BIN_DIR} | grep jdk); 
  do
    jdkFqp=${BIN_DIR}${jdk}
    echo "Add ${jdkFqp}"
    "$HOME"/.jenv/bin/jenv add "${jdkFqp}" >/dev/null 2>&1;
  done

  #echo 'Set jdk 1.6 globally'
  #"$HOME"/.jenv/bin/jenv global 1.6

  output=$(update-alternatives --list java)
  while read -r jdkFqp;
  do
    echo "Add ${jdkFqp}"
    IFS=/ read -ra array <<< "$jdkFqp"
    elements=${#array[@]}
    let elements=$((elements-3))
    echo "elements:${elements}"
    javaHome=""
    for (( i=${elements}; i>0; i--));
    do 
	echo "prefix:${javaHome} with: /${array[$i]}"
	javaHome=/${array[$i]}${javaHome}
    done	
    "$HOME"/.jenv/bin/jenv add "${javaHome}" >/dev/null 2>&1;
  done <<< "$output"

  echo 'Install node.js'
  "$HOME"/.nodenv/bin/nodenv install 4.2.1 >/dev/null 2>&1
  "$HOME"/.nodenv/bin/nodenv global 4.2.1

  set -e
}


installApp() {
  local tool_name=$1
  local file=$2
  local url=$3
  local link_target=${BIN_DIR}$4
  local link_name=${BIN_DIR}$5
  echo "Installing $tool_name"
  downloadFile=${DOWNLOAD_DIR}${file};
  download "$url" "$file"
  echo -n "Installing from $file"
  
  if [[ "$file" =~ .*tar.gz$ || "$file" =~ .*tgz$ ]]
  then 
    #echo " using tar"
    extract "${downloadFile}"
  else
    if [[ "$file" =~ .*zip$ ]]
    then
      #echo " using unzip"
      unzip "$file" >/dev/null 2>&1
    else
      echo
      echo "Can't extract $file. Unknown ext"
    fi
  fi
  echo "Creating symbolic link $link_name to $link_target"
  ln -sf $link_target $link_name 
}

installMvn()
{
  installApp 'apache-maven' \
    apache-maven-3.3.9-bin.tar.gz \
    http://supergsego.com/apache/maven/maven-3/3.3.9/binaries/ \
    'apache-maven*' \
    apache-maven

  #installPackage maven
  echo "Apache Maven installed"

  cp ${VAGRANT_DIR}toolchains.xml ${HOME_DIR}.m2
  echo "Maven toolchains configured"
}

installAnt()
{
  installApp 'apache-ant' \
    apache-ant-1.9.6-bin.tar.gz \
    http://www.eu.apache.org/dist/ant/binaries/ \
    'apache-ant*' \
    apache-ant
    
  echo "Apache Ant installed"
}

installEclipse() {
  echo "Downloading Eclipse"
  local file=eclipse-jee-mars-R-linux-gtk-x86_64.tar.gz
  if [ ! -e "$file" ]
  then
      wget -P ${DOWNLOAD_DIR} -q --progress=bar http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/mars/R/eclipse-jee-mars-R-linux-gtk-x86_64.tar.gz&r=1
  fi
  extract ${DOWNLOAD_DIR}${file}
}

installIntelliJ() {
  echo "Install IntelliJ IDEA"
  # file=ideaIC-14.1.5.tar.gz
  local file=ideaIC-15.0.1.tar.gz
  download http://download.jetbrains.com/idea/ ${file}

  extract ${DOWNLOAD_DIR}${file}
}

installAndroidSdk() {

    echo "Install Android SDK"
    local file=android-sdk_r24.4.1-linux.tgz
    download http://dl.google.com/android/ ${file}

    extract ${DOWNLOAD_DIR}${file}

    #set COMPONENTS="platform-tools,android-19,extra-android-support"
    #set LICENSES="android-sdk-license-5be876d5|mips-android-sysimage-license-15de68cc|intel-android-sysimage-license-1ea702d1"
    #curl -L https://raw.github.com/embarkmobile/android-sdk-installer/version-2/android-sdk-installer | bash /dev/stdin --install=$COMPONENTS --accept=$LICENSES && source ~/.android-sdk-installer/env  >/dev/null 2>&1;
    
    echo "y" | ${BIN_DIR}android-sdk-linux/tools/android -s update sdk -u --filter platform-tools
    echo "y" | ${BIN_DIR}android-sdk-linux/tools/android -s update sdk -u --filter android-19
    echo "y" | ${BIN_DIR}android-sdk-linux/tools/android -s update sdk -u --filter extra-android-support

    echo "Android Install complete"
}

installChrome() {
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
  sudo apt-get update >/dev/null 2>&1
  installPackage google-chrome-stable
}

info() {
  echo "Provisioning your Base Box for Open Retail 2.2 development"
}

run() {
  info 
  createDirs
  installMvn
  #installAnt
  installPackages
  installJdks
  installIbmJdk
  installNodeJs
  installAndroidSdk
  #installEnvManagers
  #installRuntimes
  installIntelliJ
  #installEclipse
  installChrome
  updateBashrc

  echo "add DNS search names"
  sudo sh -c 'echo search corp.gtech.com gtk.gtech.com > /etc/resolvconf/resolv.conf.d/base'
  echo "fix jed keymap for backspace"
  sudo sh -c 'echo "map_input (8, 127);" > /home/vagrant/.jedrc'

}


run
echo "Provisioning is complete"



