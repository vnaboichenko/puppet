class nagios::hosts::tomcat {
  # Checks for tomcat

  require nagios::hosts::generic

  @@nagios_service { "TomCat__HeapMemoryUsage $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_tomcat_HeapMemoryUsage!'-w 4000000000 -c 54000000000'",
    host_name           => $nagios_hostname,
    servicegroups       => 'TOMCAT_GROUP',
    service_description => 'TomCat__HeapMemoryUsage',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }


  @@nagios_service { "TomCat__ThreadCount $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_tomcat_ThreadCount!'-w 400 -c 500'",
    host_name           => $nagios_hostname,
    servicegroups       => 'TOMCAT_GROUP',
    service_description => 'TomCat__ThreadCount',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "TomCat__check_tomcat_httpThreads $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_tomcat_httpThreads!'-w 70 -c 80'",
    host_name           => $nagios_hostname,
    servicegroups       => 'TOMCAT_GROUP',
    service_description => 'TomCat__check_tomcat_httpThreads',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "TomCat__System_Memory_Usage $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_tomcat_SystemMemory!'-w 80 -c 90'",
    host_name           => $nagios_hostname,
    servicegroups       => 'TOMCAT_GROUP',
    service_description => 'TomCat__System_Memory_Usage',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "TomCat__System_CPU_Usage $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_tomcat_SystemCPU!'-w 80 -c 90'",
    host_name           => $nagios_hostname,
    servicegroups       => 'TOMCAT_GROUP',
    service_description => 'TomCat__System_CPU_Usage',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }







}