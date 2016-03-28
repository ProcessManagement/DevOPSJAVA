exec { "apt-get update":
  path => "/usr/bin",
}

package { "vim":
  ensure => "installed",
}

package { "curl":
  ensure => "installed",
  require => Exec["apt-get update"],  
}

package { "daemon":
  ensure => "installed",
  require => Exec["apt-get update"],  
}

package { "openjdk-7-jre-headless":
  ensure  => "installed",
  require => Exec["apt-get update"],
}

class { "jbossas": 
  bind_address => '0.0.0.0',
  bind_address_management => '0.0.0.0',
  system_properties => [
    {'name' => 'first_name', 'value' => 'adam'},
    {'name' => 'last_name', 'value' => 'brightwell'}
  ],
  require => Package["openjdk-7-jre-headless"],
}

exec { "jbossas add admin user":
  command => "/usr/share/jboss-as/bin/add-user.sh --silent=true admin secret",
  require => Class["jbossas"],
  logoutput => "on_failure",
}
