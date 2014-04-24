class epel_repo  {
    file {"/etc/yum.repos.d/epel.repo":
	owner => "root",
        group => "root",
        alias => "epel_repo",
	source => "puppet:///epel_repo/etc/yum.repos.d/epel.repo",
	before => File["epel_testing_repo"],
        }

    file {"/etc/yum.repos.d/epel-testing.repo":
	owner => "root",
        group => "root",
        alias => "epel_testing_repo",
	source => "puppet:///epel_repo/etc/yum.repos.d/epel-testing.repo",
	before => Exec["yum_clean_all_epel"]
        }

	exec { "yum_clean_all_epel":
	    name      => "/usr/bin/yum clean all",
	    logoutput => true,
	}


}