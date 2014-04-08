class nginx_lb(
$upstreams,
$port='8480',
)
 {


require local_repo


    exec {"nginx_install":
	cwd     => "/etc",
	command => "/usr/bin/yum --disablerepo=* --enablerepo=mirantis-local -y install nginx",
	before => File["nginx.conf"],
}


    file { "/etc/nginx/nginx.conf":
	ensure => present,
        owner => "root",
        group => "root",
        alias => "nginx.conf",
        content => template("nginx_lb/etc/nginx/nginx.conf.erb"),
        notify  => Service["nginx"],
	before => File["scale"],
        }


    file {"/etc/nginx/scale":
	ensure => directory,
	owner => root,
	group => root,
	alias => scale,
        notify  => Service["nginx"],
	before => File["scale_magnetodb"]
}


    file {"/etc/nginx/scale/magnetodb_list":
	ensure => present,
	owner => root,
	content => template("nginx_lb/etc/nginx/scale/magnetodb_list.erb"),
        notify  => Service["nginx"],
	group => root,
	alias => scale_magnetodb,
}

    service {"nginx":
        ensure => running,
	enable => true,
	restart => "/etc/init.d/nginx reload",
#	restart => "/bin/echo 123",
    }




}
