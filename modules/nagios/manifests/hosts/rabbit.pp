class nagios::hosts::rabbit {
  # Checks for tomcat

  require nagios::hosts::generic

  @@nagios_service { "RABBIT_QUEUE_RPC $::fqdn":
    ensure              => present,
    check_command       => 'use_nrpe!check_rabbit_queue!"-q rpc -w 20 -c 50"',
    host_name           => $nagios_hostname,
    servicegroups       => 'RABBIT_GROUP',
    service_description => 'RABBIT_QUEUE_RPC',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "RABBIT_QUEUE_STATLOGS $::fqdn":
    ensure              => present,
    check_command       => 'use_nrpe!check_rabbit_queue!"-q StatLogs -w 500 -c 1000"',
    host_name           => $nagios_hostname,
    servicegroups       => 'RABBIT_GROUP',
    service_description => 'RABBIT_QUEUE_STATLOGS',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "RABBIT_PROC $::fqdn":
    ensure              => present,
    check_command       => 'use_nrpe!check_local_procs!"-a /usr/sbin/rabbitmq-server -c 2:2"',
    host_name           => $nagios_hostname,
    servicegroups       => 'RABBIT_GROUP',
    service_description => 'Rabbit Processes',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }





}