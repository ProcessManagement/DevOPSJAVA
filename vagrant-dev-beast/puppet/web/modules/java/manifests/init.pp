class java {
	package {"oracle-java7-installer":
		ensure => latest
	}

	exec {'accept license and install java':
		command => "echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections",
		before => Package["oracle-java7-installer"],
	}
}

