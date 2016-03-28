class must-have {
  include apt
  apt::ppa { "ppa:webupd8team/java": }

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    before => Apt::Ppa["ppa:webupd8team/java"],
  }

  exec { 'apt-get update 2':
    command => '/usr/bin/apt-get update',
    require => [ Apt::Ppa["ppa:webupd8team/java"], Package["git-core"] ],
  }

  package { ["vim",
             "curl",
             "git-core",
             "bash"]:
    ensure => present,
    require => Exec["apt-get update"],
    before => Apt::Ppa["ppa:webupd8team/java"],
  }

  package { ["oracle-java8-installer"]:
    ensure => present,
    require => Exec["apt-get update 2"],
    before => Package["libswt-gtk-3-java"],
  }

  package { [ "libswt-gtk-3-java"]:
    ensure => present,
  }

  exec {
    "accept_license":
    command => "echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections",
    cwd => "/home/vagrant",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    require => Package["curl"],
    before => Package["oracle-java8-installer"],
    logoutput => true,
  }

  exec { "download eclipse":
    command => "wget http://eclipse.mirror.triple-it.nl/technology/epp/downloads/release/luna/R/eclipse-standard-luna-R-linux-gtk-x86_64.tar.gz",
    cwd => "/home/vagrant",
    path => "/usr/bin/:/bin/",
  }

  exec { "unpack eclipse":
    command => "tar zxvf /home/vagrant/eclipse-standard-luna-R-linux-gtk-x86_64.tar.gz",
    cwd => "/home/vagrant",
    require => Exec["download eclipse"],
    path => "/usr/bin/:/bin/",
  }
  
}

include must-have
