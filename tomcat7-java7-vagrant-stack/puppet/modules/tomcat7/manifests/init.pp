
class tomcat7 { 

$catalina_download_url = "http://www.eu.apache.org/dist/tomcat/tomcat-7/v7.0.62/bin/apache-tomcat-7.0.62.tar.gz"
$catalina_archive = "apache-tomcat-7.0.62.tar.gz"
$catalina_home = "/opt/apache-tomcat-7.0.62"
$catalina_folder = "apache-tomcat-7.0.62"
$user = "tomcat"
$group = "tomcat"


exec { "get_tomcat7":
  cwd       => "/tmp",
  timeout   => 900,
  path      => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
  command   => "wget --no-check-certificate --no-cookies ${catalina_download_url}",
  creates   => "/tmp/${catalina_archive}",
  require   => Package["wget"],
  logoutput => "on_failure"
}



group {  $group: ensure => present, require => Exec['get_tomcat7'], }

user { $user:
    ensure    => present,
    comment   => "Tomcat User",
    home      => "/home/$user",
    shell     => "/bin/bash",
    gid    => $group,
    require => Group["$group"],
  }


exec { "setup_tomcat7":
  creates => "${catalina_home}",
  command => "tar xfvz /tmp/${catalina_archive}",
  path    => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
  cwd     => "/opt",
  require => User["$user"],
}

file { "/etc/profile.d/catalina.sh":
  content => "export CATALINA_HOME=${catalina_home}
                  export PATH=\$PATH:\$CATALINA_HOME/bin",
  require => Exec['setup_tomcat7'],
}

file { "${catalina_home}/webapps":
  ensure  => directory,
  purge   => true,
  recurse => true,
  force   => true,
  require => Exec['setup_tomcat7'],
}

file { "${catalina_home}/conf/server.xml":
    ensure  => "present",
    source  => "/workspace/server.xml",
    require => Exec['setup_tomcat7'],
  }
  
 
  file { "${catalina_home}/bin/catalina.sh":
		ensure => present,
		owner => "$user",
		group => "$group",
		mode => '0755',
		source => '/workspace/catalina.sh',
}

 file { "example-webapp":
   ensure => present,
   path => "${catalina_home}/webapps/ROOT/",
   source => "/workspace/ROOT-example-web-app/",
   recurse => true,
   require => File["${catalina_home}/bin/catalina.sh"],
}


  exec { "start_tomcat7":
  command => "${catalina_home}/bin/catalina.sh start",
  path    => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
  cwd     => "${catalina_home}/bin/",
  require => File['example-webapp'],
}
}
