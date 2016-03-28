# Install PHP 5.4 PPA and required packages 
class php54 {

	exec {'add php54 apt-repo':
		command => '/usr/bin/add-apt-repository ppa:ondrej/php5',
		require => Package['python-software-properties'],
	}
}
