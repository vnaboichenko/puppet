class nagios::hosts::cassandra {
  # Checks for cassandra

  require nagios::hosts::generic

$nagios_hostname=$hostname    



  @@nagios_service { "Cassandra Partition $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_disk_cassandra!'-c 20%  -w 10% -p /opt/storage'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra Partition',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "Cassandra__HeapMemoryUsage $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra_HeapMemoryUsage!'-w 4000000000 -c 54000000000'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra__HeapMemoryUsage',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }


  @@nagios_service { "Cassandra_write_speed $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra_read_write_speed!'-o WriteOperations'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra_write_speed',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }
  @@nagios_service { "Cassandra_read_speed $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra_read_write_speed!'-o ReadOperations'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra_read_speed',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "Cassandra__System_Memory_Usage $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra_SystemMemory!'-w 80 -c 90'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra__System_Memory_Usage',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "Cassandra__System_CPU_Usage $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra_SystemCPU!'-w 80 -c 90'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra__System_CPU_Usage',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }


  @@nagios_service { "Cassandra__StorageProxy__TotalReadLatencyMicros $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra__org__apache__cassandra.db__type__StorageProxy__TotalReadLatencyMicros!'-w 1  -c 1'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra__StorageProxy__TotalReadLatencyMicros',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }



  @@nagios_service { "Cassandra__StorageProxy__TotalWriteLatencyMicros $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra__org__apache__cassandra.db__type__StorageProxy__TotalWriteLatencyMicros!'-w 1  -c 1'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra__StorageProxy__TotalWriteLatencyMicros',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }





  @@nagios_service { "Cassandra__FlushWriter__ActiveCount $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra__org__apache__cassandra__internal__type__FlushWriter__ActiveCount!'-w 10 -c 100'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra__FlushWriter__ActiveCount',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }





  @@nagios_service { "Cassandra__FlushWriter__CompletedTasks $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra__org__apache__cassandra__internal__type__FlushWriter__CompletedTasks!'-w 1  -c 1'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra__FlushWriter__CompletedTasks',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }





#  @@nagios_service { "Cassandra__ColumnFamilies__keyspace__clickatell__columnfamily__REGULAR_INDEX_UTF8TYPE__ReadCount $ipaddress":
#    ensure              => present,
#    check_command       => "use_nrpe!check_cassandra__org__apache__cassandra__db__type__ColumnFamilies__keyspace__clickatell__columnfamily__REGULAR_INDEX_UTF8TYPE__ReadCount!'-w 1  -c 1'",
#    host_name           => $nagios_hostname,
#    servicegroups       => 'CASSANDRA_GROUP',
#    service_description => 'Cassandra__ColumnFamilies__keyspace__clickatell__columnfamily__REGULAR_INDEX_UTF8TYPE__ReadCount',
#    use                 => 'nagios-graph-service',
#    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
#    tag                 => $::deployment_id,
#    notify              => Service["nagios"],
#    require             => File[$nagios::params::nagios_dirs]
#  }


#  @@nagios_service { "Cassandra__ColumnFamilies__keyspace__clickatell__columnfamily__REGULAR_INDEX_UTF8TYPE__WriteCount $ipaddress":
#    ensure              => present,
#    check_command       => "use_nrpe!check_cassandra__org__apache__cassandra__db__type__ColumnFamilies__keyspace__clickatell__columnfamily__REGULAR_INDEX_UTF8TYPE__WriteCount!'-w 1  -c 1'",
#    host_name           => $nagios_hostname,
#    servicegroups       => 'CASSANDRA_GROUP',
#    service_description => 'Cassandra__ColumnFamilies__keyspace__clickatell__columnfamily__REGULAR_INDEX_UTF8TYPE__WriteCount',
#    use                 => 'nagios-graph-service',
#    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
#    tag                 => $::deployment_id,
#    notify              => Service["nagios"],
#    require             => File[$nagios::params::nagios_dirs]
#  }
#
#
#
#  @@nagios_service { "Cassandra__ColumnFamilies__keyspace__clickatell__columnfamily__REGULAR_INDEX_UTF8TYPE__LiveSSTableCount $ipaddress":
#    ensure              => present,
#    check_command       => "use_nrpe!check_cassandra__org__apache__cassandra__db__type__ColumnFamilies__keyspace__clickatell__columnfamily__REGULAR_INDEX_UTF8TYPE__LiveSSTableCount!'-w 1  -c 1'",
#    host_name           => $nagios_hostname,
#    servicegroups       => 'CASSANDRA_GROUP',
#    service_description => 'Cassandra__ColumnFamilies__keyspace__clickatell__columnfamily__REGULAR_INDEX_UTF8TYPE__LiveSSTableCount',
#    use                 => 'nagios-graph-service',
#    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
#    tag                 => $::deployment_id,
#    notify              => Service["nagios"],
#    require             => File[$nagios::params::nagios_dirs]
#  }



  @@nagios_service { "Cassandra__CompactionManager__TotalCompactionsCompleted $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra__org__apache__cassandra__db__type__CompactionManager__TotalCompactionsCompleted!'-w 1  -c 1'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra__CompactionManager__TotalCompactionsCompleted',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }





  @@nagios_service { "Cassandra__CompactionManager__PendingTasks $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra__org__apache__cassandra__db__type__CompactionManager__PendingTasks!'-w 10  -c 50'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra__CompactionManager__PendingTasks',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }




  @@nagios_service { "Cassandra__CompactionManager__CompletedTasks $ipaddress":
    ensure              => present,
    check_command       => "use_nrpe!check_cassandra__org__apache__cassandra__db__type__CompactionManager__CompletedTasks!'-w 1  -c 1'",
    host_name           => $nagios_hostname,
    servicegroups       => 'CASSANDRA_GROUP',
    service_description => 'Cassandra__CompactionManager__CompletedTasks',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }



}
