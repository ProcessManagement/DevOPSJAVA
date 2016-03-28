exec { "apt-get update":
  path => "/usr/bin",
}

exec { "uk-mirror":
  command   => 'sed -i "s|us\.archive\.ubuntu|www.mirrorservice.org/sites/archive.ubuntu|g" /etc/apt/sources.list',
  path       => '/bin',
}

apt::key { 'webupd8':
  key        => 'EEA14886',
  key_server => 'keyserver.ubuntu.com',
}

exec { 'add-datastax-key':
  command => 'curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -',
  path => '/usr/bin/',
  require => Package["curl"],
}

apt::source { 'datastax':
  location          =>  'http://debian.datastax.com/community',
  repos             =>  'main',
  release           =>  'stable',
  include_src       =>  false,
}

apt::source { 'webupd8team':
  location          =>  'http://ppa.launchpad.net/webupd8team/java/ubuntu',
  repos             =>  'main',
  release           =>  'precise',
  include_src       =>  false,
}

exec { 'accept-java-license':
  command => '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections;/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true | sudo /usr/bin/debconf-set-selections;',
}


package {
  "curl":
    ensure  => present,
    before  => Package["vim","oracle-java6-installer"],
    require => Exec["uk-mirror","apt-get update"];
  "vim":
    ensure  => present;
 "oracle-java6-installer":
    ensure  => present,
    require => [Package["curl"],Exec["uk-mirror","apt-get update","accept-java-license"],Apt::Source["webupd8team"]],
    before => Package["oracle-java6-set-default","dsc12","cassandra"];
  "oracle-java6-set-default":
    ensure  => present;
  "cassandra":
    ensure  => "1.2.15",
    before => Package["dsc12"],
    require => [Package["oracle-java6-installer"],Exec["uk-mirror","apt-get update","accept-java-license","add-datastax-key"],Apt::Source["datastax"]];
  "dsc12":
    ensure  => "1.2.15-1",
    require => [Package["oracle-java6-installer","cassandra"],Exec["uk-mirror","apt-get update","accept-java-license","add-datastax-key"],Apt::Source["datastax"]];
}

service { "cassandra":
 ensure  => "stopped",
 require => Package["cassandra"],
}

tidy { "cassandra-system":
   path => "/var/lib/cassandra/data/system/*",
}
