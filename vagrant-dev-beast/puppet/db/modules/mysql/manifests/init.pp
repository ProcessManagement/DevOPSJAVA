class mysql {
	$mysqlPassword = "root"

	package {"mysql-server-5.5":
		ensure => present,
		require => Exec['apt-get update']
	}

	package {'mysql-client-5.5':
		ensure => present,
		require => Exec['apt-get update']
	}

	service {'mysql':
		enable => true,
		ensure => running, 
		require => Package["mysql-server-5.5"]
	}

	exec {'set-mysql-password':
		unless => "mysqladmin -uroot -p$mysqlPassword status",
		command => "mysqladmin -uroot password $mysqlPassword",
		require => Service["mysql"] 
	}
	
}
