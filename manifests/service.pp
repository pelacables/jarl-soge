# == Class: soge::service
#
# This class creates the soge service (sysV)
# future TODO: use camptocamp/systemd
#  systemd::unit_file { "sgeexecd.${_soge_cluster_name}":
#    source    => 'puppet:///modules/soge/soge.service',
#    enable    => $execd_enable,
#    active    => $execd_ensure,
#    hasstatus => false,
#  }
#
class soge::service (
  $_manage_service    = $::soge::manage_service,
  $_soge_service_name = $::soge::soge_service_name,
  $_node_type         = $::soge::node_type,
  $_soge_cluster_name = $::soge::soge_cluster_name,
  $_soge_root         = $::soge::soge_root,
  $_soge_cell         = $::soge::soge_cell,
  $_soge_qmaster_name = $::soge::soge_qmaster_name,
  $_soge_qmaster_port = $::soge::soge_qmaster_port,
  $_soge_execd_port   = $::soge::soge_execd_port,
) {

  if ($_manage_service == true) and ("${_node_type}" == 'execution') {
    contain systemd
    file { '/etc/sysconfig/sgeexecd' :
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('soge/sgeexecd.erb');
    }
    ~> systemd::unit_file { "${_soge_service_name}" :
         source  => 'puppet:///modules/soge/sgeexecd.service';
    }
    ~> service { "${_soge_service_name}":
        ensure    => 'running',
        enable    => true,
        hasstatus => false,
    }
  }

}
