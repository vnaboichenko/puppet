class nagios::hosts::statistics {
  # Checks for tomcat

  require nagios::hosts::generic

  @@nagios_service { "Statistics_Calculation $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_statistics_calculation!'-test'",
    host_name           => $nagios_hostname,
    servicegroups       => 'HADOOP_GROUP',
    service_description => 'Statistics_Calculation',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "Hadoop_JobTracker_proc $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_local_procs!'-a jobtracker -c 1:1'",
    host_name           => $nagios_hostname,
    servicegroups       => 'HADOOP_GROUP',
    service_description => 'Hadoop_JobTracker_proc',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "Hadoop_NameNode_proc $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_local_procs!'-a namenode -c 2:2'",
    host_name           => $nagios_hostname,
    servicegroups       => 'HADOOP_GROUP',
    service_description => 'Hadoop_NameNode_proc',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "Hadoop Partition $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_disk_hadoop!'-c 20%  -w 10% -p /opt/clickatell/storage-1'",
    host_name           => $nagios_hostname,
    servicegroups       => 'HADOOP_GROUP',
    service_description => 'Hadoop Partition',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }


}