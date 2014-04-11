class nagios::hosts::nginx {
  # Checks for tomcat

  require nagios::hosts::generic

  @@nagios_service { "Check_Nginx $::fqdn":
    ensure              => present,
    check_command       => "use_nrpe!check_nginx!'-H localhost -P 80 -p /var/run -w 200 -c 400'",
    host_name           => $nagios_hostname,
    servicegroups       => 'NGINX_GROUP',
    service_description => 'Check_Nginx',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }

  @@nagios_service { "Check_Api_healthcheck $::fqdn":
    ensure              => present,
    check_command       => 'check_http_api_health',
    host_name           => $nagios_hostname,
    servicegroups       => 'NGINX_GROUP',
    service_description => 'Check_Api_healtheck',
    use                 => 'nagios-graph-service',
    target              => "$nagios::params::nagios_base/hosts/services/${env}_${nagios_hostname}.cfg",
    tag                 => $::deployment_id,
    notify              => Service["nagios"],
    require             => File[$nagios::params::nagios_dirs]
  }





}