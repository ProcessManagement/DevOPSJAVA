class java7 {
   
$java_download_url = "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz"
$java_archive = "jdk-7u79-linux-x64.tar.gz"
$java_home = "/opt/jdk1.7.0_79"
$java_folder = "jdk1.7.0_79"

exec { 'get_java7':
  cwd       => "/tmp",
  timeout   => 900,
  path      => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
  command   => "wget --no-check-certificate --no-cookies --header \"Cookie: oraclelicense=accept-securebackup-cookie\" ${java_download_url}",
  creates   => "/tmp/${java_archive}",
  require   => Package["wget"],
  logoutput => "on_failure"
}

exec { "setup_java7":
  creates => "${java_home}",
  command => "tar xfvz /tmp/${java_archive}",
  path    => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
  cwd     => "/opt",
  require => Exec["get_java7"],
}

exec { "install_java7":
  require   => Exec['setup_java7'],
  logoutput => true,
  path      => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
  command   => "update-alternatives --install /bin/java java ${java_home}/bin/java 1"
}

exec { "set_java7":
  require   => Exec['install_java7'],
  logoutput => true,
  path      => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
  command   => "update-alternatives --set java ${java_home}/bin/java"
}

exec { 'install_javac7':
  require   => Exec["setup_java7"],
  logoutput => true,
  path      => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
  command   => "update-alternatives --install /bin/javac javac ${java_home}/bin/javac 1"
}

exec { 'set_javac7':
  require   => Exec['install_javac7'],
  logoutput => true,
  path      => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
  command   => "update-alternatives --set javac ${java_home}/bin/javac"
}

file { "/etc/profile.d/java.sh":
  content => "export JAVA_HOME=${java_home}
                  export PATH=\$PATH:\$JAVA_HOME/bin
                  export JRE_HOME=${java_home}/jre",
  require => Exec['set_javac7'],
}

}
