class magnetodb (
$seeds,
$packages = [ 'build-essential', 'libev4', 'libev-dev', 'python-pip', 'git', 'gcc', 'python-dev' ],
#$magneto_url = 'https://github.com/stackforge/magnetodb.git',
$magneto_url = 'https://github.com/gluke77/magnetodb.git',
$magneto_path = '/opt/magnetodb/',
$checkout     = 'remotes/origin/bp/bulk-data-load-over-network'
) 
{

package { $packages:
	ensure => installed,
	before => Exec["clone_magneto"],
 }

class {'magnetodb::gluke':
	seeds => $seeds,
}

exec { 'clone_magneto':
	command => "/usr/bin/git clone $magneto_url $magneto_path",
	creates => "$magneto_path",
}


if $checkout {
exec { 'cd_branch_magneto':
	cwd     => "$magneto_path",
	command => '/usr/bin/git checkout remotes/origin/bp/bulk-data-load-over-network',
	require => Exec["clone_magneto"],
	before  => Exec["install_magneto"],
}

	
}
	



file { "$magneto_path/etc/magnetodb-api.conf":
	ensure => present,
	content => template('magnetodb/magnetodb-api.conf.erb'),
	require => Exec["clone_magneto"],
}

file { '/var/log/magnetodb/':
	ensure => directory,
	content => template('magnetodb/magnetodb-api.conf.erb'),
	before  => Exec["start_magneto"],
}


        	exec { "add to the limits":
		command => "/bin/echo 'session required pam_limits.so' >> /etc/pam.d/common-session",
		unless =>  "/bin/cat /etc/pam.d/common-session | grep 'session required pam_limits.so'",
	before  => Exec["start_magneto"],
		}

        file { "/etc/security/limits.d/magneto.conf":
               alias => "cassandra-limits",
                content => '* soft memlock unlimited
* hard memlock unlimited
* soft nofile 65536
* hard nofile 65536',
              owner => "root",
                group => "root",
                mode => "644",
	before  => Exec["start_magneto"],
        }


exec { 'install_magneto':
 	command => "/usr/bin/pip install -e $magneto_path",
#	onlyif  => '/bin/ps xau | grep magnetodb-api-server',
	require => File["$magneto_path/etc/magnetodb-api.conf"],
	before  => Exec["start_magneto"],
}
exec { 'start_magneto':
 	command => "/usr/bin/python $magneto_path/bin/magnetodb-api-server --config-dir $magneto_path/etc/ &",
#	onlyif  => '/bin/ps xau | grep magnetodb-api-server',
	require => File["$magneto_path/etc/magnetodb-api.conf"],

}



}
