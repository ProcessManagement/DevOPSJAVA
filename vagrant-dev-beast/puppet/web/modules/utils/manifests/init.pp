class utils {
	package {'curl': 
		ensure => present,
		require => Exec['apt-get update']
	}

	package {"python-software-properties":
		ensure => present,
	}

	package {'vim':
		ensure => present,
	}

	package {'git':
		ensure => present
	}
}
