

$routes = ['192.168.1.2', '192.168.1.3', '192.168.1.4']



node /haproxy-*/ {

class {'haproxy':

upstreams => hiera('magnetodb_upstreams'),
port    => hiera('magnetodb_port'),
}
}



node "magneto-puppet" {

class { "test":
 
#routes => hiera('seeds2'),
#routes => $routes,
}

}

node /nginx-*/ {

class {'nginx_lb':

upstreams => hiera('magnetodb_upstreams'),
port    => hiera('magnetodb_port'),
}
}

node /magneto-client-*/ {


class {'magnetodb':
seeds    => hiera('seeds'),
}

}

node /magnetodbapi-*/ {


class {'magnetodb':
seeds    => hiera('seeds'),
}

}

node /cassandra-*/ {


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



	$deployment_id   = "test2"
	$env 		= "dev"
node "magnetodb-1" {

	$nagios_hostname = "$hostname_$ipaddress"
class {'nagios::server':
     }
#include monitoring

}


node "magneto-2" {

	$nagios_hostname = "$hostname_$ipaddress"
       include nagios::hosts::generic 


}


