# Remove Apache2 from server because its slow
class apache {
	package {'apache2':
		ensure => purged	
	}	

	package {'apache2-utils':
		ensure => purged
	}
}
