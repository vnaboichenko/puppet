class java (

$java_base    = '/opt/',
$java_tarbar = '7u51-linux-x64',
$java_version = '1.7.0_51'
){




    file {"/etc/profile.d/java.sh":
	ensure => present,
	owner => "root",
        group => "root",
        alias => "java.sh",
        content => template("java/java.sh.erb"),
	}


#        file { "${java_base}/jdk-${java_tarbar}.tar.gz":
 #               alias => "java-source-tgz",
#		source => "puppet:///java/jdk-${java_tarbar}.tar.gz",
#                group => "root",
#                owner => "root",
#		before => Exec["untar-java"],
 #       }

        exec { "update_alternatives_java":
                command => "/usr/sbin/update-alternatives --install /usr/bin/java java ${java_base}jdk${java_version}/bin/java 1",
                user => "root",
		require => Exec["untar-java"],
        }

        exec { "wget jdk-${java_tarbar}.tar.gz":
                cwd => "${java_base}",
                command => '/usr/bin/wget --no-check-certificate --no-cookies - --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.tar.gz',
                creates => "${java_base}jdk${java_version}",
		returns => 4,
                alias => "java-source-tgz",
                user => "root",
        }



        exec { "untar jdk-${java_tarbar}.tar.gz":
                cwd => "${java_base}",
                command => "/bin/tar -zxf jdk-${java_tarbar}.tar.gz",
                creates => "${java_base}jdk${java_version}",
                alias => "untar-java",
                refreshonly => true,
                subscribe => Exec["java-source-tgz"],
                user => "root",
        }


#        file { "${java_base}/java":
#                force => true,
#                ensure => "${java_base}/jdk${java_version}",
#                alias => "java-symlink",
#                owner => "root",
#                group => "root",
#                require => Exec["untar-java"],
#        }



}
