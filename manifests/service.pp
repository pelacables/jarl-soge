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
  $_node_type         = $::soge::node_type,
  $_soge_cluster_name = $::soge::soge_cluster_name,
  $_soge_service_name = $::soge::soge_service_name,
) {

  if ($_manage_service == true) and ("${_node_type}" == 'execution')  {
    $execd_ensure = 'running'
    $execd_enable = true
  }
  else {
    $execd_ensure = 'stopped'
    $execd_enable = false
  }


  service { "${_soge_service_name}":
    ensure    => $execd_ensure,
    enable    => $execd_enable,
    hasstatus => false,
  }

}
