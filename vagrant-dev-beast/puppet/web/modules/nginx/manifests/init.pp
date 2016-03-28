# Now lets install Nginx
class nginx {
	exec {'add nginx-repo':
		command => "/usr/bin/apt-add-repository ppa:nginx/development",		
		require => Package['python-software-properties'] 
	}		

	package {'nginx':
		ensure => latest,
		require => [Exec['apt-get update'], Package['python-software-properties']]
	}	

	service {'nginx':
		ensure => running,
		require => Package['nginx'],
	}
}
