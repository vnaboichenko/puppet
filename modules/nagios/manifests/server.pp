class nagios::server(
  $update_repo = false,
  $epel_repo = false,
#  $nagios_hostname,
#  $env = 'dev',
#  $deployment_id = 'test',
)


 {


#  require nagios::hosts::generic

	class {'nagios':
#        nagios_hostname => "$nagios_hostname",
#        deployment_id   => "$deployment_id",
 #       env             => "$env",
		}
	class {'nagios::hosts::generic':
#        nagios_hostname => "$nagios_hostname",
#        deployment_id   => "$deployment_id",
#        env             => "$env",
		}

#Class["nagios::hosts::generic"] -> Class["nagios"]

  Nagios_host <<| tag == $::deployment_id |>> {
  }

  Nagios_service <<| tag == $::deployment_id |>> {
  }
  Nagios_hostgroup <<| tag == $::deployment_id |>> {
  }

}
