class oraclejava {
	exec {'add oracleJVM-repo':
		command => '/usr/bin/add-apt-repository ppa:webupd8team/java',
		require => Package['python-software-properties'] 
	}

	exec {"oracleJVM apt update":
		command => 'apt-get update',
	}
}
