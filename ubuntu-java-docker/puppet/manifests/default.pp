Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

include stdlib
include apt

apt::ppa { 'ppa:webupd8team/java': }

exec { 'accept_license':
  command => 'echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections',
  cwd  => '/home/vagrant',
  user => 'vagrant',
  path => '/usr/bin/:/bin/',
  before => Package['oracle-java8-installer'],
  logoutput => true,
}

package { 'oracle-java8-installer':
  ensure   => installed,
  require  => [ Apt::Ppa['ppa:webupd8team/java'], Exec['apt_update'] ]
}

exec { 'docker-engine':
  command => 'curl -sSL https://get.docker.com/ | sh',
  require => Exec['apt_update']
}

exec { 'docker-group':
  command => 'usermod -aG docker vagrant',
  require => Exec['docker-engine']
}

exec { 'docker-boot-at-start':
  command => 'systemctl enable docker && service docker start',
  require => [ Exec['docker-engine'], Exec['docker-group'] ]
}
