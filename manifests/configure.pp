# == Class: soge::configure
#
# Class that configures SoGE
# It also manages soge admin user if $manage_user is set to true
#
class soge::configure (
  $_soge_request      = $soge::soge_request,
  $_node_type         = $soge::node_type,
  $_manage_service    = $soge::manage_service,
  $_soge_root         = $soge::soge_root,
  $_soge_cell         = $soge::soge_cell,
  $_soge_admin_user   = $soge::oge_admin_user,
  $_soge_admin_group  = $soge::soge_admin_group
  $_soge_qmaster_name = $soge::soge_qmaster_name,
  $_soge_cluster_name = $soge::soge_cluster_name,
  $_soge_version      = $soge::version,
  $_soge_qmaster_name = $soge::soge_qmaster_name,
  $_soge_execd_port   = $soge::soge_execd_port,
  ) {

  if ($_soge_request != undef) and ($_node_type == 'submit')  {
    $ensure_soge_request = 'present'
  }
  else {
    $ensure_soge_request = 'absent'
  }

  if ($_manage_service == true) and ($_node_type == 'execution')  {
    $ensure_init_file = 'present'
  }
  else {
    $ensure_init_file = 'absent'
  }

  # soge conf files: bootstrap, settings, act_qmaster, settings.sh

  $_soge_path = "/${_soge_root}/${_soge_cell}"

  file {
    "${_soge_path}/common/act_qmaster" :
      ensure  => present,
      mode    => '0644',
      owner   => "${_soge_admin_user}",
      group   => "${_soge_admin_group}",
      content => "${_soge_qmaster_name}";
    "${_soge_path}/common/bootstrap" :
      ensure  => present,
      mode    => '0644',
      owner   => "${_soge_admin_user}",
      group   => "${_soge_admin_group}",
      content => template('soge/client/bootstrap.erb');
    "${_soge_path}/common/settings.sh" :
      ensure  => present,
      mode    => '0644',
      owner   => "${_soge_admin_user}",
      group   => "${_soge_admin_group}",
      content => template('soge/client/settings.sh.erb');
    '/etc/profile.d/soge_settings.sh' :
      ensure  => link,
      target  => "${_soge_path}/common/settings.sh",
      require => File["${_soge_path}/common/settings.sh"];
    "${_soge_path}/common/soge_request" :
      ensure  => "${ensure_soge_request}",
      mode    => '0644',
      owner   => "${_soge_admin_user}",
      group   => "${_soge_admin_group}",
      content => template('soge/client/soge_request.erb');
    "/etc/init.d/sge.${_soge_cluster_name}":
      ensure => present,
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
      content => template('soge/client/sge.service.erb');
  }
  }

}
