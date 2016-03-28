# Postgres
class { 'postgresql::server':
  ip_mask_allow_all_users    => '0.0.0.0/0',
  listen_addresses           => '*',
}

postgresql::server::db { 'light':
  user     => 'light',
  password => postgresql_password('light', 'light'),
}

# apt
package { 'python-software-properties':
  ensure => 'installed'
}

# NGINX
package { "nginx":
  ensure => "installed"
}

service { "nginx":
  ensure => "running"
}

file { "/etc/nginx/conf.d":
  notify  => Service["nginx"],
  source  => "puppet:///files/nginx/conf.d",
  recurse => true,
  force   => true,
  purge   => true,
}

file { "/etc/nginx/nginx.conf":
  notify  => Service["nginx"],
  source  => "puppet:///files/nginx/nginx.conf",
  recurse => true,
}



