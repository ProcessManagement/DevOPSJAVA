Exec {
	path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

exec {'apt-get update':
	command => '/usr/bin/apt-get update',
	require => [
		Exec['add php54 apt-repo'], 
		Exec['add oracleJVM-repo'],
		Exec['add nginx-repo']
	]
}

include bootstrap
include utils 
include php54
include oraclejava 
include php
include java
include apache
include nginx
include sites
