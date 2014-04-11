class nagios::hosts::worker {
  # Checks for tomcat

  require nagios::hosts::generic

  @@nagios_service { "Worker_proc $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_local_procs!'-a worker-jar-with-dependencies.jar -c 1:1'",
    host_name           => $nagios_hostname,
    servicegroups       => 'WORKER_GROUP',
    service_description => 'Worker_proc',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "Supervisor_proc $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_local_procs!'-a supervisord -c 1:1'",
    host_name           => $nagios_hostname,
    servicegroups       => 'WORKER_GROUP',
    service_description => 'Supervisor_proc',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }





}