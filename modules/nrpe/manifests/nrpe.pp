class nrpe_packages {
    notify { 'NRPE INFO 1':
        message => "Called nrpe_class"
    }


    case $operatingsystem  {
        Ubuntu:	{ 
	    package {
    		"nagios-nrpe-server":
    		ensure => installed
	    }
	}
    	CentOS:	{ 
	    package {
    		"nrpe":
    		ensure => installed
	    }
	}
	Amazon:	{ 
	    notify { 'NRPE INFO 2':
    		message => "AMAZON detected"
	    }
	    package {
    		"nrpe":
    		ensure => installed
	    }
	    package {
                "nagios-plugins-all":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-apt":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-breeze":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-by_ssh":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-cluster":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-dhcp":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-dig":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-disk":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-dns":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-dummy":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-file_age":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-flexlm":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-fping":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-hpjd":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-http":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-icmp":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-ide_smart":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-ifoperstatus":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-ifstatus":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-ircd":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-ldap":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-linux_raid":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-load":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-log":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-mailq":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-mrtg":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-mrtgtraf":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-mysql":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-nagios":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-nrpe":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-nt":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-ntp":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-nwstat":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-oracle":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-overcr":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-perl":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-pgsql":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-ping":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-procs":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-radius":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-real":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-rpc":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-smtp":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-snmp":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-ssh":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-swap":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-tcp":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-time":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-ups":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-users":
    		ensure => installed
	    }

	    package {
                "nagios-plugins-wave":
    		ensure => installed
	    }


	    package {
                "python-argparse.noarch":
    		ensure => installed
	    }

	}
    }
}





# определение пути для установки плагинов 
# зависит как от архитектуры так и от дистрибутива
class  nrpe_extra_plugins {
	case $::operatingsystem  {
    	    Ubuntu:	{ $NagiosPluginsPath = "/usr/lib/nagios/plugins" }
    	    CentOS:	{ $NagiosPluginsPath = "/usr/lib64/nagios/plugins" }
	    Amazon:	{ $NagiosPluginsPath = "/usr/lib64/nagios/plugins" }
#	    default:	{ $NagiosPluginsPath = "/usr/lib64/nagios/plugins" }
 }
    case $operatingsystem  {
	Ubuntu:	{ $NRPEUser = "nagios" }
    	CentOS:	{ $NRPEUser = "nrpe" }
	Amazon:	{ $NRPEUser = "nrpe" }
    }

    case $operatingsystem  {
	Ubuntu:	{ $NRPEService = "nagios-nrpe-server" }
    	CentOS:	{ $NRPEService = "nrpe" }
	Amazon:	{ $NRPEService = "nrpe" }
    }




service { 
        "$NRPEService":
        ensure => running,
	enable => true,
	stop => 'killall nrpe',
        require => Package["$NRPEService"],
        subscribe => File[nrpe_cfg]
    }


# проверить существование директории и при необходимости - создать. Вообще эта ситуация не должна возникнуть, т.к. директория создается при установке пакета.
    file { "$NagiosPluginsPath":
	ensure => "directory",
    }
    notify { 'NagiosPluginsPath":': message => "$NagiosPluginsPath"    }



# Определяю работу со списком файлов что бы не перечислять их по одному

define nrpe_plugins {
	case $::operatingsystem  {
    	    Ubuntu:	{ $NagiosPluginsPath = "/usr/lib/nagios/plugins" }
    	    CentOS:	{ $NagiosPluginsPath = "/usr/lib64/nagios/plugins" }
	    Amazon:	{ $NagiosPluginsPath = "/usr/lib64/nagios/plugins" }
#	    default:	{ $NagiosPluginsPath = "/usr/lib64/nagios/plugins" }
 }
    file {
	"/$NagiosPluginsPath/${title}":
	ensure => present,
	owner  => 'root',
	mode   => 0755,
	source => "puppet:///modules/nrpe/${title}",
	require => File["$NagiosPluginsPath"],
  }
}

    nrpe_plugins { 
	[

	    "check_cassandra_nodes.sh",
	    "check_cassandra_SystemCPU.sh",
	    "check_cassandra_SystemMemory.sh",
	    "check_cpu_load.sh",
	    "check_iostat.py",
	    "check_jmx",
	    "check_procs",
	    "check_procs_back",
	    "check_snmp_netint.pl",
	    "cass_read_write_speed.sh",
	    "check_memory_usage",
	    "check_tcp_conn_cassandra.sh",
	    "check_tcp_conn_count_tomcat.sh",
	    "check_tomcat.pl",
	    "check_tomcat_SystemCPU.sh",
	    "check_tomcat_SystemMemory.sh",
	    "check_nginx.sh",
	    "jmxquery.jar",
	    "iotop.py"
	    ]: 
	} 

    file {  nrpe_cfg:
#       source => "puppet:///files/nrpe/nrpe.cfg",
        name => "/etc/nagios/nrpe.cfg",
	content => template("nrpe/nrpe.erb"),	
	notify  => Service["$NRPEService"],
    }


    file {  check_swap_wrapper:
        name => "$NagiosPluginsPath/check_swap_wrapper",
	content => template("nrpe/check_swap_wrapper.erb"),	
	notify  => Service["$NRPEService"],
	owner  => 'root',
	mode   => 0755,
    }


    file {  check_cassandra_HeapMemoryUsage:
        name => "$NagiosPluginsPath/check_cassandra_HeapMemoryUsage.sh",
	content => template("nrpe/check_cassandra_HeapMemoryUsage.sh.erb"),	
	notify  => Service["$NRPEService"],
	owner  => 'root',
	mode   => 0755,
    }

    file {  check_cassandra_jmx:
        name => "$NagiosPluginsPath/check_cassandra_jmx.sh",
	content => template("nrpe/check_cassandra_jmx.sh.erb"),	
	notify  => Service["$NRPEService"],
	owner  => 'root',
	mode   => 0755,
    }

    file {  check_snmp_netint_wrapper:
        name => "$NagiosPluginsPath/check_snmp_netint.wrapper",
	content => template("nrpe/check_snmp_netint.wrapper.erb"),	
	notify  => Service["$NRPEService"],
	owner  => 'root',
	mode   => 0755,
    }

    file {  check_tomcat_HeapMemoryUsage:
        name => "$NagiosPluginsPath/check_tomcat_HeapMemoryUsage.sh",
	content => template("nrpe/check_tomcat_HeapMemoryUsage.sh.erb"),	
	notify  => Service["$NRPEService"],
	owner  => 'root',
	mode   => 0755,
    }

    file {  check_tomcat_ThreadCount:
        name => "$NagiosPluginsPath/check_tomcat_ThreadCount.sh",
	content => template("nrpe/check_tomcat_ThreadCount.sh.erb"),	
	notify  => Service["$NRPEService"],
	owner  => 'root',
	mode   => 0755,
    }

    file {  check_rabbit_queue:
        name => "$NagiosPluginsPath/check_rabbit_queue.sh",
	content => template("nrpe/check_rabbit_queue.sh.erb"),
	notify  => Service["$NRPEService"],
	owner  => 'root',
	mode   => 0755,
    }

    file {  check_worker_connection:
        name => "$NagiosPluginsPath/check_worker_connection.sh",
        content => template("nrpe/check_worker_connection.sh.erb"),
        notify  => Service["$NRPEService"],
        owner  => 'root',
        mode   => 0755,
    }

    file {  check_calculate:
        name => "$NagiosPluginsPath/check_calculate.sh",
        content => ("nrpe/check_calculate.sh.erb"),
        notify  => Service["$NRPEService"],
        owner  => 'root',
        mode   => 0755,
    }



    file {  check_cassandra_backups:
        name => "$NagiosPluginsPath/check_cassandra_backups.sh",
	content => template("nrpe/check_cassandra_backups.sh.erb"),
	notify  => Service["$NRPEService"],
	owner  => 'root',
	mode   => 0755,
    }



    file {  check_hdfs:
        name => "$NagiosPluginsPath/check_hdfs.sh",
	content => template("nrpe/check_hdfs.sh.erb"),
	notify  => Service["$NRPEService"],
	owner  => 'root',
	mode   => 0755,
    }





    file {  check_tomcat_httpThreads:
        name => "$NagiosPluginsPath/check_tomcat_httpThreads.sh",
	content => template("nrpe/check_tomcat_httpThreads.sh.erb"),	
	notify  => Service["$NRPEService"],
	owner  => 'root',
	mode   => 0755,
    }




#snmpd.conf

    define replace($file, $pattern, $replacement) {
    
	notify { 'replace_0': message => "call replace $pattern ==>  $replacement in $file"    }

	$pattern_no_slashes = regsubst($pattern, '/', '\\/', 'G', 'U')
	$replacement_no_slashes = regsubst($replacement, '/', '\\/', 'G', 'U')

	notify { 'replace_1': message => "call replace $pattern_no_slashes ==>  $replacement_no_slashes in $file"    }

	exec { "replace_${pattern}_${file}":
	    command => "/usr/bin/perl -pi -e 's/${pattern_no_slashes}/${replacement_no_slashes}/' '${file}'",
	    alias => "exec_$name",
	}
    }


}
