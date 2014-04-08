class local_repo  {
    file {"/etc/yum.repos.d/local.repo":
	owner => "root",
        group => "root",
        alias => "local_repo",
	content => template('local_repo/local.repo.erb'),
	before => Exec["yum_clean_all_local"],
        }

        exec { "yum_clean_all_local":
            name      => "/usr/bin/yum clean all",
            logoutput => true,
        }
}
