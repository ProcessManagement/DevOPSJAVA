class php {
	$packages = [
		"php5",
		"php5-cli",
		"php5-fpm",
		"php5-dev",
		"php5-xdebug",
		"php-apc",
		"php-pear",
		"php5-curl"
	]

	package {
		$packages:
			ensure => latest,
			require => [Exec['apt-get update'], Package['python-software-properties']]
	}
}
