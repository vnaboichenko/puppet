class test ( 
#$port = '8480',
#$routes = ['192.168.1.2', '192.168.1.3', '192.168.1.4'],
)
 {
  $members = [
        'localhost:3000',
        'localhost:3001',
        'localhost:3002',
  ]


#$fullroute = inline_template("<%= routes.join(', ') %>")

#forMagneto
#$fullroute = inline_template("<%= 'server ' + routes.join('; \n') + ';' %>")

#$fullroute = inline_template("<%= routes %>")

@@file { '/tmp/1':
  ensure  => present,
  content => $::ipaddress_eth1,
}


  File <<| |>> {
  }



}
