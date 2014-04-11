class cassandra (
$max_heap     = '3G',
$download_url = 'http://archive.apache.org',
$heap_newsize = '800M',
$version      = '2.0.7',
$jmx_port     = '7199',
$mount	      = 'undef',
$bind_address = "$::ipaddress_eth0",
$seeds        = ["$::ipaddress_eth0"],
$initial_token = '',
$cluster_name = 'Test Cluster',
$cassandra_log_path = '/var/log/cassandra',
$cassandra_base = '/opt/',
$data_path = '/opt/storage/cassandra/data',
$commitlog_directory = '/opt/storage/cassandra/commitlog',
$saved_caches = '/opt/storage/cassandra/saved_caches',
$java_base = '/opt/',
$java_tarbar = '7u51-linux-x64',
$java_version = '1.7.0_51',
$ntp_status = 'running',
) {


#$seeds_to_conf = inline_template("<%= seeds.join(', ') %>")


file { '/tmp/1':
  ensure  => present,
  content => "$seeds_to_conf",
}
class { 'java':
java_tarbar => $java_tarbar,
java_version => $java_version,
java_base    =>  $java_base,
 }


 if $max_heap == 'undef' 
	    { fail("'\$max_heap' is not defined, plese enter \$max_heap='1700M'") 
		    }

 if $seeds == 'undef' 
	    { fail("'\$seeds' is not defined") 
		    }


 if $heap_newsize == 'undef' 
	    { fail("'\$heap_newsize' is not defined, plese enter \$heap_newsize='800M'") 
		    }

  package { "ntp":
    ensure => installed,
        }

  service { "ntp":
    ensure => $ntp_status,
        }
        
        group { "cassandra":
		ensure => present,
		gid => "900",
	}

	user { "cassandra":
		ensure => present,
		comment => "Cassandra",
		password => "!!",
		uid => "900",
		gid => "900",
		shell => "/bin/bash",
		home => "/home/cassandra",
		require => Group["cassandra"],
	}
	
	file { "/home/cassandra/.bash_profile":
		ensure => present,
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-bash_profile",
		content => template("cassandra/home/bash_profile.erb"),
		require => User["cassandra"]
	}
		
	file { "/home/cassandra":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-home",
		require => [ User["cassandra"], Group["cassandra"] ],
	}
	
        file {"${cassandra::cassandra_base}/storage":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cass-storage",
		require => User["cassandra"]
	}

        file {"${cassandra::cassandra_base}":
		ensure => "directory",
		mode  => '777',
#		owner => "cassandra",
#		group => "cassandra",
		require => User["cassandra"]
	}

#    if $mount != 'undef' {
#    
#
#
#
#
#
#    mount { "${cassandra::cassandra_base}clickatell/storage-2":
#	device  => "/dev/$mount",
#	fstype  => "ext4",
#	ensure  => "mounted",
#	alias => "mount_xvd",
#	options => "defaults",
#	require => File["cass-storage"],
#	before => File["cassandra_dir"],
#            }

#}

        file {"${cassandra::cassandra_base}/storage/cassandra":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra_dir",
		require => File["cass-storage"]
	}

        
        file {"$cassandra::cassandra_log_path":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-log-path",
        require => File["cassandra_dir"]
	}
	
        file {"$cassandra::data_path":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-data-path",
	}
        
        file {"$cassandra::commitlog_directory":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-commitlog-directory",
    		require => File["cassandra_dir"]
	}
        
        file {"$cassandra::saved_caches":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-saved-caches",
    		require => File["cassandra_dir"]
	}
        


        	exec { "dw_cassandra":
		cwd => "${cassandra::cassandra_base}",
#		command => "/usr/bin/wget ${download_url}/dist/cassandra/${cassandra::version}/apache-cassandra-${cassandra::version}-bin.tar.gz",
		command => "/usr/bin/wget http://162.242.173.125/dist/cassandra/${cassandra::version}/apache-cassandra-${cassandra::version}-bin.tar.gz",
		alias => "cassandra-source-tgz",
		creates => "${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}-bin.tar.gz",
		user => "cassandra",
		before => Exec["untar-cassandra"],
		require => File["cassandra_dir"]
		}


        	exec { "add to the limits":
		command => "/bin/echo 'session required pam_limits.so' >> /etc/pam.d/common-session",
		unless =>  "/bin/cat /etc/pam.d/common-session | grep 'session required pam_limits.so'"
		}

#        	exec { "add to the limits2":
#		command => "/bin/echo '
#* soft nofile 32768
#* hard nofile 32768
#root soft nofile 32768
#root hard nofile 32768' >> /etc/security/limits.conf",
#		unless =>  "/bin/cat /etc/security/limits.conf | grep 'root soft nofile 32768'"
#		}


        exec { "untar apache-cassandra-${cassandra::version}-bin.tar.gz":
		cwd => "${cassandra::cassandra_base}",
		command => "/bin/tar -zxf apache-cassandra-${cassandra::version}-bin.tar.gz",
		creates => "${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}",
		alias => "untar-cassandra",
		refreshonly => true,
		subscribe => Exec["cassandra-source-tgz"],
		user => "cassandra",
		before => [ File["cassandra-symlink"], File["cassandra-app-dir"]]
	}
        
        file { "${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}":
		ensure => "directory",
		mode => 0644,
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-app-dir",
                before => [ File["cassandra-yaml"], File["cassandra-log4j"], File["cassandra-env"] ]
	}
		
	file { "${cassandra::cassandra_base}/cassandra":
		force => true,
		ensure => "${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}",
		alias => "cassandra-symlink",
		owner => "cassandra",
		group => "cassandra",
		require => Exec["untar-cassandra"],
	}
        
   
        file { "${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}/conf/cassandra.yaml":
                alias => "cassandra-yaml",
                content => template("cassandra/conf/cassandra.yaml.erb"),
                owner => "cassandra",
                group => "cassandra",
                mode => "644",
                require => File["cassandra-app-dir"]
        }
        
        file { "${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}/conf/cassandra-env.sh":
                alias => "cassandra-env",
                content => template("cassandra/conf/cassandra-env.sh.erb"),
                owner => "cassandra",
                group => "cassandra",
                mode => "644",
                require => File["cassandra-app-dir"]
        }


	file {"${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}/bin/cassandra":
		ensure => present,
                content => template("cassandra/bin/cassandra.erb"),
		owner => "cassandra",
		group => "cassandra",
		mode => "755",
	}

  

        
        file { "${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}/conf/log4j-server.properties.back":
                alias => "cassandra-log4j",
                content => template("cassandra/conf/log4j-server.properties.erb"),
                owner => "cassandra",
                group => "cassandra",
                mode => "644",
                require => File["cassandra-app-dir"]
        }

        file { "/etc/init.d/cassandra":
                alias => "cassandra-init",
                content => template("cassandra/cassandra_init.erb"),
                owner => "cassandra",
                group => "cassandra",
                mode => "755",
                require => User["cassandra"]
        }

        file { "/etc/security/limits.d/cassandra.conf":
               alias => "cassandra-limits",
                content => template("cassandra/cassandra.conf.erb"),
              owner => "root",
                group => "root",
                mode => "644",
                require => User["cassandra"]
        }




 #       exec { "mx4j-tools.jar":
#		cwd => "${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}/lib/",
#		command => "/usr/bin/wget http://bigdata-repo.mirantis.com/archives/cassandra/mx4j-tools.jar",
#		creates => "${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}/lib/mx4j-tools.jar",
#		user => "cassandra",
#	        require => Exec["untar-cassandra"],
#	}

#        exec { "gelfj-1.0.1.jar":
#		cwd => "${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}/lib/",
#		command => "/usr/bin/wget http://bigdata-repo.mirantis.com/archives/cassandra/gelfj-1.0.1.jar",
#		creates => "${cassandra::cassandra_base}/apache-cassandra-${cassandra::version}/lib/gelfj-1.0.1.jar",
#		user => "cassandra",
#	        require => Exec["untar-cassandra"],
#	}

host { "$hostname":
	ip => "$::ipaddress",
	ensure => present,
}


}
