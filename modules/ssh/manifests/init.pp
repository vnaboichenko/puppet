class ssh (
$ssh_packages = 'ssh',
$ssh_packages1 = 'ssh1'
)

{

  package { $ssh_packages:
    ensure => present,
  }

  package { $ssh_packages1:
    ensure => present,
  }
#  file { '/etc/ssh/sshd_config':
#    ensure  => present,
#    owner   => 'root',
#    group   => 'root',
#    mode    => '0644',
#    # Template uses $permit_root_login and $ssh_users
#    content => template('ssh/sshd_config.erb'),
#}
  service { 'ssh':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
