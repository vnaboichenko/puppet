class nagios::hosts::generic (
#  $nagios_hostname,
#  $env,
#  $deployment_id,
)

 {
  # default checks like cpu,memory,loadaverage

  require nagios::params
			    $ipaddress = "$::ipaddress"
$nagios_hostname=$hostname    
  
  @@nagios_host { "$nagios_hostname":
    ensure     => present,
    alias      => $nagios_hostname,
    host_name  => "$nagios_hostname",
    address    => $ipaddress,
#    address    => $::ec2_public_ipv4,
    hostgroups => $env,
    use        => 'linux-server',
    target     => "$nagios::params::nagios_base/hosts/${env}_${nagios_hostname}.cfg",
    tag        => $::deployment_id,
    notify     => Service["nagios"],
    require    => File[$nagios::params::nagios_dirs],
  }


  @@nagios_service { "iotop_writes_reads $ipaddress":
    ensure              => present,
    check_command       => 'use_nrpe!check_iotop!"-w 30 -c 90"',
    host_name           => $nagios_hostname,
    servicegroups       => 'GENERIC_GROUP',
    service_description => 'IOTOP WRITES READS',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "ping $ipaddress":
    ensure              => present,
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    host_name           => $nagios_hostname,
    servicegroups       => 'GENERIC_GROUP',
    service_description => 'PING',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "current_users $ipaddress":
    ensure              => present,
    check_command       => 'use_nrpe!check_local_users!"-c 20  -w 50"',
    host_name           => $nagios_hostname,
    servicegroups       => 'GENERIC_GROUP',
    service_description => 'Current Userds',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "Ethernet_0 $ipaddress":
    ensure              => present,
    check_command       => 'check_iface_load!MoNiToR!"eth0"!75,75,0,0,0,0!85,85,0,0,0,0!300',
    host_name           => $nagios_hostname,
    servicegroups       => 'GENERIC_GROUP',
    service_description => 'Eth0',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "Total Procs $ipaddress":
    ensure              => present,
    check_command       => 'use_nrpe!check_local_procs!"-w 250 -c 400"',
    host_name           => $nagios_hostname,
    servicegroups       => 'GENERIC_GROUP',
    service_description => 'Total Processes',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }


  @@nagios_service { "iostat $ipaddress":
    ensure              => present,
    check_command       => 'use_nrpe!check_iostat!"-w 80 -c 90"',
    host_name           => $nagios_hostname,
    servicegroups       => 'GENERIC_GROUP',
    service_description => 'iostat',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }


  @@nagios_service { "Check_local_swap $ipaddress":
    ensure              => present,
    check_command       => 'use_nrpe!check_local_swap!"-w 95 -c 90"',
    host_name           => $nagios_hostname,
    servicegroups       => 'GENERIC_GROUP',
    service_description => 'Check_swap',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }



  @@nagios_service { "ssh $ipaddress":
    ensure              => present,
    check_command       => 'check_ssh',
    host_name           => $nagios_hostname,
    servicegroups       => 'GENERIC_GROUP',
    service_description => 'SSH',
    use                 => 'local-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "loadaverage $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_local_load!'-w 5.0,4.0,3.0 -c 10.0,6.0,4.0'",
    host_name           => $nagios_hostname,
    servicegroups       => 'GENERIC_GROUP',
    service_description => 'Current Load',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "cpu_load $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cpu_load!'-h 127.0.0.1 -w 70 -c 90'",
    host_name           => $nagios_hostname,
    servicegroups       => 'GENERIC_GROUP',
    service_description => 'CPU',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "disk_usage $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_local_disk!'-c 20%  -w 10% -p /'",
    host_name           => $nagios_hostname,
    servicegroups       => 'GENERIC_GROUP',
    service_description => 'Root Partition',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

#  @@nagios_service { "memory_usage $ipaddress":
#    ensure              => present,
#    check_command       => "use_nrpe!check_memory_usage!'-f -w 10% -c 5%'",
#    host_name           => $nagios_hostname,
#    servicegroups       => 'GENERIC_GROUP',
#    service_description => 'Memory Usage',
#    use                 => 'nagios-graph-service',
#    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
#    tag                 => $::deployment_id,
#    notify              => Service["nagios"],
#    require             => File[$nagios::params::nagios_dirs]
 # }

}
