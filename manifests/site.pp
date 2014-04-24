	$deployment_id   = "moe_lab"
	$env 		= "dev"
        $nagios_host    = '10.0.0.30'
	$nagios_hostname = $hostname

import "nrpe/nrpe"
stage { [1, 2, 3, 4]: }
Stage[1] -> Stage[main] -> Stage[2] -> Stage[3] -> Stage[4]



#class for nagios
class monitoring {

	class {'nrpe_packages':
		stage => 1,
	}
	class {'nrpe_extra_plugins':
		stage => 2,
	}
	class {'snmpd':
		stage => 3,
	}
}

node "Datastax" {

include java

}




node /haproxy-*/ {

class {'magnetodb':
seeds    => hiera('seeds'),
}
include nagios::hosts::generic 
include monitoring
#class {'haproxy':

#upstreams => hiera('magnetodb_upstreams'),
#port    => hiera('magnetodb_port'),
#}
}



node "magneto-puppet" {

class { "test":
 
#routes => hiera('seeds2'),
#routes => $routes,
}

}

node /nginx-*/ {

class {'magnetodb':
seeds    => hiera('seeds'),
}
class {'nginx_lb':

upstreams => hiera('magnetodb_upstreams'),
port    => hiera('magnetodb_port'),
}
}

node /magneto-client-*/ {


include nagios::hosts::generic 
include monitoring


class {'magnetodb':
seeds    => hiera('seeds'),
}

}

node /magnetodbapi-*/ {

include nagios::hosts::generic 
include monitoring
class {'magnetodb':
seeds    => hiera('seeds'),
}

}




node /cassandra-*/ {


#include nagios::hosts::cassandra
#include monitoring
class {"cassandra":

seeds    => hiera('seeds'),
initial_token => hiera('initial_token'),
max_heap     => hiera('max_heap'),
heap_newsize => hiera('heap_newsize'),
version      => hiera('version'),
cluster_name => hiera('cluster_name'),
java_tarbar  => hiera('java_tarbar'),
java_version => hiera('java_version'),


}

}



node "nagios" {

	$nagios_hostname = "$hostname_$ipaddress"
class {'nagios::server':
     }
include monitoring

}


node "magneto-2" {

	$nagios_hostname = "$hostname_$ipaddress"
       include nagios::hosts::generic 


}




node "node-15" {

	$nagios_hostname = "$hostname_$ipaddress"
class {'nagios::server':
     }
include monitoring

#include epel_repo

}


node 'node-8', 'node-9', 'node-10','node-11' {

	$nagios_hostname = "API_$hostname"
       include nagios::hosts::generic 

include monitoring

}

node 'node-1', 'node-2', 'node-3','node-4', 'node-5', 'node-6' {


include nagios::hosts::cassandra
include monitoring
class {"cassandra":

seeds    => ['10.0.0.5', '10.0.0.21', '10.0.0.29', '10.0.0.25', '10.0.0.17', '10.0.0.7'],
initial_token => hiera('initial_token'),
max_heap     => hiera('max_heap'),
heap_newsize => hiera('heap_newsize'),
version      => hiera('version'),
cluster_name => hiera('cluster_name'),
java_tarbar  => hiera('java_tarbar'),
java_version => hiera('java_version'),


}

}
