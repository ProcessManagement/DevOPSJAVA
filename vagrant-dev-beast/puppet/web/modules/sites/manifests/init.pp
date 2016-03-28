# Load server configurations in Nginx 
class sites {
	$sites = [
		"html-8090",
		"php-8080"
	]

	define site_links {
		$base = "/sites"
		$site = $name

		$fullPath = "$base/$site"
		$linkPath = "/etc/nginx/sites-enabled/$site"

		file { $linkPath:
			ensure => link,	
			target => $fullPath 
		}	
	}
	
	site_links{$sites:;}

}
