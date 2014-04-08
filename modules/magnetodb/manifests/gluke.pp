class magnetodb::gluke (
$seeds,


) 
{


exec { 'pip-install json':
	command => '/usr/bin/pip install ujson',
	before  => Exec["clone_gluke"],
}

exec { 'clone_gluke':
	command => '/usr/bin/git clone https://github.com/gluke77/magnetodb.git /opt/gluke',
	creates => '/opt/gluke',
}


exec { 'cd_branch_gluke':
	cwd     => '/opt/gluke',
	command => '/usr/bin/git checkout remotes/origin/bp/bulk-data-load-over-network',
	require => Exec["clone_gluke"],
}


file {"/opt/gluke/poc/bulk_load/bulk_load_server.py":
	ensure => present,
	require => Exec['cd_branch_gluke'],
	content => template('magnetodb/bulk_load_server.py.erb'),
}

exec { 'install_gluke':
 	command => '/usr/bin/pip install -e /opt/gluke',
#	onlyif  => '/bin/ps xau | grep magnetodb-api-server',
	require => File["/opt/gluke/poc/bulk_load/bulk_load_server.py"],
	before  => Exec["start_gluke"],
}
exec { 'start_gluke':
 	command => '/usr/bin/python /opt/gluke/poc/bulk_load/bulk_load_server.py &',
#	onlyif  => '/bin/ps xau | grep magnetodb-api-server',
	require => Exec["install_gluke"],

}






}
