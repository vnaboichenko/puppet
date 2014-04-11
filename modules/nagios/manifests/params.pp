class nagios::params {
  $nagios_packages = ["httpd", "php", "nagios", "pnp4nagios", "mutt"]
  $nagios_base = "/etc/nagios"
  $service_groups = [ "GENERIC_GROUP", "TOMCAT_GROUP", "NGINX_GROUP", "HADOOP_GROUP", "CASSANDRA_GROUP", "WORKER_GROUP", "RABBIT_GROUP" ]
  $host_groups = [ "dev", "mirantis-qa", "igor-qa", "arisent-qa", "int", "prod", "stage", "uat", "aricent-qa" ]
  $nagios_dirs = [
    "${nagios_base}/commands",
    "${nagios_base}/contacts",
    "${nagios_base}/objects",
    "${nagios_base}/hosts",
    "${nagios_base}/hosts/services",
    "${nagios_base}/host-groups",
    "${nagios_base}/service-groups",
    "${nagios_base}/mutt",
]
  $nagios_rm_files = [
    "${nagios_base}/objects/windows.cfg",
    "${nagios_base}/objects/switch.cfg",
    "${nagios_base}/objects/printer.cfg",
    "${nagios_base}/objects/contacts.cfg",
    "${nagios_base}/objects/localhost.cfg",
    "${nagios_base}/objects/templates.cfg",]
  $name_contact = "mmaxur"
  $name_passwd = "qwer90"
  $email_contact = "root@localhost"
}

