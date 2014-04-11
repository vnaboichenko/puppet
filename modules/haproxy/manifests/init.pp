class haproxy (
$upstreams,
$port,
)
{

package {"haproxy":
	ensure => present,
}

file {"/etc/haproxy/haproxy.cfg":
	ensure => present,
	content => template('haproxy/haproxy.cfg.erb'),
	require => Package["haproxy"],
	before => Service["haproxy"],
	notify => Service["haproxy"],
}


service {'haproxy':
ensure => running,
enable => true,
}





}
