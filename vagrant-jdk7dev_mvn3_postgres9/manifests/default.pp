class must-have {
  include apt
  apt::ppa { "ppa:webupd8team/java": 
    before => Class['jboss'],
  }

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

  package { ["oracle-java7-installer"]:
    ensure => present,
    require => Exec["apt-get update 2"],
    before => Package["libswt-gtk-3-java"],
  }

  package { [ "libswt-gtk-3-java", "maven", "postgresql-9.1", "postgresql-client-9.1"]:
    ensure => present,
    require => Exec["apt-get update 2"],
  }

  exec {
    "accept_license":
    command => "echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections",
    cwd => "/home/vagrant",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    require => Package["curl"],
    before => Package["oracle-java7-installer"],
    logoutput => true,
  }

  exec { "download eclipse":
#    command => "wget http://eclipse.mirror.triple-it.nl/technology/epp/downloads/release/luna/R/eclipse-standard-luna-R-linux-gtk-x86_64.tar.gz",
    command => "wget http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/luna/R/eclipse-jee-luna-R-linux-gtk-x86_64.tar.gz",
    cwd => "/home/vagrant",
    path => "/usr/bin/:/bin/",
    creates => "/home/vagrant/eclipse-jee-luna-R-linux-gtk-x86_64.tar.gz"
  }

  exec { "unpack eclipse":
    command => "tar zxvf /home/vagrant/eclipse-jee-luna-R-linux-gtk-x86_64.tar.gz",
    cwd => "/home/vagrant",
    require => Exec["download eclipse"],
    path => "/usr/bin/:/bin/",
  }

  class { 'jboss':
    bindaddr    => '0.0.0.0',
  }
  
}

include must-have
