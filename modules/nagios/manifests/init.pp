class nagios (
  $update_repo = false,
  $epel_repo = false,
#$nagios_hostname,
#$env = 'dev',
#$deployment_id = 'test',

) 
{
  require nagios::params

    if $epel_repo {
	class {"epel_repo":}
	}  
	
  notify { 'INF2':
    message => "CLASS NAGIOS"
  }

notify{"The value is: $deployment_id": }

  if $update_repo {
    exec { "update_repo":
      command => "/usr/bin/apt-get update",
      before  => Package[$nagios::params::nagios_packages]
    }
  }

  package { $nagios::params::nagios_packages:
    ensure => "present",
    before => Exec["nagios_passwd"],
  }

  exec { "nagios_passwd":
    command => "/usr/bin/htpasswd -cb ${nagios::params::nagios_base}/passwd $nagios::params::name_contact $nagios::params::name_passwd",
    require => Package[$nagios::params::nagios_packages]
  }

  file { $nagios::params::nagios_dirs:
    ensure  => directory,
    owner   => nagios,
    group   => nagios,
    require => Package[$nagios::params::nagios_packages]
  }

  file { "/etc/default/npcd":
    ensure  => present,
    content => template("nagios/etc/default/npcd.erb"),
    owner   => root,
    notify  => Service["npcd"],
    before  => Service["npcd"],
    group   => root,
    require => Package[$nagios::params::nagios_packages]
  }

  nagios_contact { $nagios::params::name_contact:
    ensure  => present,
    alias   => 'Nagios Admin',
    email   => $nagios::params::email_contact,
    use     => 'generic-contact',
    target  => "$nagios::params::nagios_base/contacts/contacts.cfg",
    tag     => $::deployment_id,
    notify  => Service["nagios"],
    require => File[$nagios::params::nagios_dirs],
  }

  nagios_contactgroup { "admins":
    ensure  => present,
    contactgroup_name => 'admins',
    members => "$nagios::params::name_contact",
    target  => "$nagios::params::nagios_base/contacts/contact-group.cfg",
    tag     => $::deployment_id,
    notify  => Service["nagios"],
    require => File[$nagios::params::nagios_dirs],
  }



  nagios_service { generic-service:
    ensure                => present,
    name                  => 'generic-service',
    max_check_attempts    => '3',
    normal_check_interval => '10',
    retry_check_interval  => '2',
    active_checks_enabled          => '1',
    passive_checks_enabled         => '1',
    parallelize_check             => '1',
    obsess_over_service           => '1',  
    check_freshness               => '0', 
    notifications_enabled           => '1',
    event_handler_enabled           => '1',
    flap_detection_enabled          => '1',
    failure_prediction_enabled     => '1',
    process_perf_data              => '1', 
    retain_status_information      => '1', 
    retain_nonstatus_information   => '1',
    is_volatile                    => '0', 
    check_period                    => '24x7',
    contact_groups => 'admins',
    register              => '0',
    target                => "$nagios::params::nagios_base/objects/generic-service.cfg",
    tag                   => $::deployment_id,
    notify                => Service["nagios"],
    require               => File[$nagios::params::nagios_dirs],
  }

  nagios_service { local-service:
    ensure                => present,
    name                  => 'local-service',
    use                   => 'generic-service',
    max_check_attempts    => '4',
    normal_check_interval => '5',
    retry_check_interval  => '1',
    register              => '0',
    target                => "$nagios::params::nagios_base/objects/local-service.cfg",
    tag                   => $::deployment_id,
    notify                => Service["nagios"],
    require               => File[$nagios::params::nagios_dirs],
  }


  nagios_service { nagios-graph-service:
    ensure                => present,
    name                  => 'nagios-graph-service',
    use                   => 'generic-service',
    max_check_attempts    => '4',
    normal_check_interval => '5',
    retry_check_interval  => '1',
    register              => '0',
    action_url            => '/pnp4nagios/index.php/graph?host=$HOSTNAME$&srv=$SERVICEDESC$',
    target                => "$nagios::params::nagios_base/objects/nagios-graph-service.cfg",
    contacts              => "$nagios::params::name_contact",
    tag                   => $::deployment_id,
    notify                => Service["nagios"],
    require               => File[$nagios::params::nagios_dirs],
  }


  nagios_host { generic-host:
    ensure                	 => present,
    name                  	 => 'generic-host',
    notifications_enabled   	 => '1',
    event_handler_enabled 	 => '1',
    flap_detection_enabled    	 => '1',
    failure_prediction_enabled   => '1',
    process_perf_data    	 => '1',
    retain_status_information	 => '1',
    retain_nonstatus_information => '1',
    notification_period 	 => '24x7',
    register              	 => '0',
    target                	 => "$nagios::params::nagios_base/objects/generic-host.cfg",
    tag                   	 => $::deployment_id,
    notify                	 => Service["nagios"],
    require               	 => File[$nagios::params::nagios_dirs],
  }


  define nagios_hostgroups {
    nagios_hostgroup  { "${title}":
        name    => "${title}",
        alias   => "${title}",
        target  => "$nagios::params::nagios_base/host-groups/host-groups.cfg",
        tag     => $::deployment_id,
        notify  => Service["nagios"],
        require => File[$nagios::params::nagios_dirs],
                
    }
  }

  nagios_hostgroups { $nagios::params::host_groups:
  ;
  }


  nagios_host { linux-server:
    ensure                => present,
    name                  => 'linux-server',
    check_period          => '24x7',
    check_interval        => '5',
    retry_interval        => '1',
    max_check_attempts    => '10',
    check_command         => 'check-host-alive',
    notification_period   => 'workhours',
    notification_interval => '120',
    notification_options  => 'd,u,r',
    contact_groups        => 'admins',
    register              => '0',
    use                   => 'generic-host',
    target                => "$nagios::params::nagios_base/objects/linux-server.cfg",
    tag                   => $::deployment_id,
    notify                => Service["nagios"],
    require               => File[$nagios::params::nagios_dirs],
  }

  nagios_contact { generic-contact:
    ensure   => present,
    alias    => 'Generic Contact',
    register => '0',
    service_notification_period   => '24x7',
    host_notification_period      => '24x7',
    service_notification_options  => 'w,u,c,r,f,s',
    host_notification_options     => 'd,u,r,f,s',
    service_notification_commands => 'notify-service-by-email-mutt',
    host_notification_commands    => 'notify-host-by-email-mutt',
    target   => "$nagios::params::nagios_base/contacts/contacts.cfg",
    tag      => $::deployment_id,
    notify   => Service["nagios"],
    require  => File[$nagios::params::nagios_dirs],
  }

  nagios_command { use_nrpe:
    ensure       => "present",
    command_name => "use_nrpe",
    command_line => '/usr/lib64/nagios/plugins/check_nrpe -t 40 -H $HOSTADDRESS$ -c $ARG1$ -a $ARG2$',
    target       => "$nagios::params::nagios_base/commands/commands.cfg",
    tag          => $::deployment_id,
    notify       => Service["nagios"],
    require      => File[$nagios::params::nagios_dirs],
  }

  nagios_command { check_iface_load:
    ensure       => "present",
    command_name => "check_iface_load",
    command_line => '$USER1$/check_snmp_netint.wrapper -P -r -t 10  -H $HOSTADDRESS$ -C $ARG1$ -2 -f  -n $ARG2$ -w$ARG3$ -c$ARG4$ -d $ARG5$ -q -k -M -B',
    target       => "$nagios::params::nagios_base/commands/commands.cfg",
    tag          => $::deployment_id,
    notify       => Service["nagios"],
    require      => File[$nagios::params::nagios_dirs],
  }


  nagios_command { check_http_api_health:
    ensure       => "present",
    command_name => 'check_http_api_health',
    command_line => '$USER1$/check_http -I $HOSTADDRESS$ -v -u "/api/v1/details/healthcheck"',
    target       => "$nagios::params::nagios_base/commands/commands.cfg",
    tag          => $::deployment_id,
    notify       => Service["nagios"],
    require      => File[$nagios::params::nagios_dirs],
  }




  nagios_command { notify-host-by-email-mutt:
    ensure       => "present",
    command_name => "notify-host-by-email-mutt",
    command_line => '/usr/bin/printf "%b" "NotifType: $NOTIFICATIONTYPE$\nHost:$HOSTNAME$\nState:$HOSTSTATE$\nAddress:$HOSTADDRESS$\nInfo:$HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /usr/bin/mutt -s "STAGE CLICKATELL: $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$" -F /etc/nagios/mutt/.muttrc  $CONTACTEMAIL$ 2>>/var/log/nagios_mail >>/var/log/nagios_mail',
    target       => "$nagios::params::nagios_base/commands/commands.cfg",
    tag          => $::deployment_id,
    notify       => Service["nagios"],
    require      => File[$nagios::params::nagios_dirs],
  }


  nagios_command { notify-service-by-email-mutt:
    ensure       => "present",
    command_name => "notify-service-by-email-mutt",
    command_line => '/usr/bin/printf "%b" " Nagios \n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTNAME$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$\n" | /usr/bin/mutt -s " $NOTIFICATIONTYPE$ Service Alert: $HOSTNAME$/$SERVICEDESC$ is $SERVICESTATE$ " -F /etc/nagios/mutt/.muttrc $CONTACTEMAIL$',
    target       => "$nagios::params::nagios_base/commands/commands.cfg",
    tag          => $::deployment_id,
    notify       => Service["nagios"],
    require      => File[$nagios::params::nagios_dirs],
  }


  define nagios_servicegroups {
    nagios_servicegroup { "${title}":
        name    => "${title}",
        alias   => "${title}",
        target  => "$nagios::params::nagios_base/service-groups/service-groups.cfg",
        tag     => $::deployment_id,
        notify  => Service["nagios"],
        require => File[$nagios::params::nagios_dirs],
                
    }
  }

  nagios_servicegroups { $nagios::params::service_groups:
  ;
  }


  # this files dont need
  file { $nagios::params::nagios_rm_files:
    ensure  => "absent",
    before  => File["nagios.cfg"],
    require => File[$nagios::params::nagios_dirs],
  }

  file { "${nagios::params::nagios_base}/nagios.cfg":
    ensure  => "present",
    content => template("nagios${nagios::params::nagios_base}/nagios.cfg.erb"),
    require => File[$nagios::params::nagios_dirs],
    owner   => nagios,
    notify  => [Service["httpd"], Service["nagios"]],
    alias   => "nagios.cfg",
    group   => nagios,
  }


  file { "${nagios::params::nagios_base}/mutt/.muttrc":
    ensure  => "present",
    content => template("nagios${nagios::params::nagios_base}/mutt/.muttrc.erb"),
    require => File[$nagios::params::nagios_dirs],
    owner   => nagios,
    notify  => [Service["httpd"], Service["nagios"]],
    alias   => "muttrc.cfg",
    group   => nagios,
  }


  file { "${nagios::params::nagios_base}/cgi.cfg":
    ensure  => "present",
    content => template("nagios${nagios::params::nagios_base}/cgi.cfg.erb"),
    require => File[$nagios::params::nagios_dirs],
    owner   => nagios,
    notify  => [Service["httpd"], Service["nagios"]],
    alias   => "cgi.cfg",
    group   => nagios,
  }


#  exec { 'nagios_external_cmd_perms_overrides':
#    command   => 
#    '/usr/sbin/dpkg-statoverride --update --add nagios www-data 2710 /var/lib/nagios/rw && /usr/sbin/dpkg-statoverride --update --add nagios nagios 751 /var/lib/nagios',
#    unless    => 
#    '/usr/sbin/dpkg-statoverride --list nagios www-data 2710 /var/lib/nagios/rw && /usr/sbin/dpkg-statoverride --list nagios nagios 751 /var/lib/nagios',
#    logoutput => false,
#    require   => Package[$nagios::params::nagios_packages],
#    notify    => Service['nagios'],
#    before    => Service['nagios'],
#  }

  service { "npcd":
    ensure  => "running",
    enable  => "true",
    require => File["nagios.cfg"],
  }

  service { "httpd":
    ensure  => "running",
    enable  => "true",
    require => File["nagios.cfg"],
  }

  service { "nagios":
    ensure  => "running",
    enable  => "true",
    require => File["nagios.cfg"],
  }

}

