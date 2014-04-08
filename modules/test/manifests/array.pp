
$worker_ips = [ "192.168.0.1",
"192.168.0.2",
]
$entry_point_ips = ["10.0.0.1",
"10.0.0.2",
]
$master_ips = [ "192.168.15.1",
]

$all_ips = split(inline_template("<%= (worker_ips+entry_point_ips+master_ips).join(',') %>"),',')
tell_me{$all_ips:}
