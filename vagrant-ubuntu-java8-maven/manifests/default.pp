class java-development-env {
  include apt
  include maven
  include '::mysql::server'

  apt::ppa { "ppa:webupd8team/java": }

#  # Set current Tomcat download url.
#  $tomcat_url = "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz"

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    before => Apt::Ppa["ppa:webupd8team/java"],
  }

  exec { 'apt-get update 2':
    command => '/usr/bin/apt-get update',
    require => [ Apt::Ppa["ppa:webupd8team/java"], Package["git-core"] ],
  }

  # install necessary ubuntu packages to setup the environment
  package { ["vim",
             "curl",
             "git-core",
             "expect",
             "mc",
             "bash"]:
    ensure => present,
    require => Exec["apt-get update"],
    before => Apt::Ppa["ppa:webupd8team/java"],
  }

  package { ["oracle-java8-installer"]:
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
    before => Package["oracle-java8-installer"],
    logoutput => true,
  }

  maven::settings { 'mvn-settings' :
    local_repo => '/vagrant/maven/.m2/repository',
#    servers    => [$server],
  }

  Exec {
    path  => "${::path}",
  }

  group { "puppet":
    ensure  => present,
  }

  package { "acpid":
    ensure  => installed,
  }

  package { "supervisor":
    ensure  => installed,
  }

  package { "wget":
    ensure  => installed,
  }

  user { "vagrant":
    ensure    => present,
    comment   => "Tomcat User",
    home      => "/home/vagrant",
    shell     => "/bin/bash",
  }


}

include java-development-env
