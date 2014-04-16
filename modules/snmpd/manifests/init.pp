class snmpd {
    case $operatingsystem  {
        Ubuntu:	{ 
	    package {
    		"snmpd":
    		ensure => installed
	    }

	}
    	centos:	{ 
	    package {
    		"net-snmp":
    		ensure => installed
	    }

	    package {
    		"net-snmp-libs":
    		ensure => installed
	    }

	    package {
    		"net-snmp-utils":
    		ensure => installed
	    }


	}
	Amazon:	{ 
	    package {
    		"net-snmp":
    		ensure => installed
	    }

	    package {
    		"net-snmp-libs":
    		ensure => installed
	    }

	    package {
    		"net-snmp-utils":
    		ensure => installed
	    }

	}
    }

    service { 
        "snmpd":
	enable => true,
        ensure => running,
        subscribe => File[snmpd_cfg]
    }


    file {  snmpd_cfg:
        name => "/etc/snmp/snmpd.conf",
	content => template("snmpd/snmpd.erb"),	
	notify  => Service["snmpd"],
    }


}