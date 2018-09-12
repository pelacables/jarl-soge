# == Class: soge::configure
#
# Class that configures SoGE
# It also manages soge admin user if $manage_user is set to true
#
class soge::configure (
  $_soge_request      = $::soge::soge_request,
  $_node_type         = $::soge::node_type,
  $_manage_service    = $::soge::manage_service,
  $_soge_root         = $::soge::soge_root,
  $_soge_cell         = $::soge::soge_cell,
  $_soge_admin_user   = $::soge::soge_admin_user,
  $_soge_admin_group  = $::soge::soge_admin_group,
  $_soge_qmaster_name = $::soge::soge_qmaster_name,
  $_soge_cluster_name = $::soge::soge_cluster_name,
  $_soge_version      = $::soge::version,
  $_soge_execd_port   = $::soge::soge_execd_port,
  $_soge_qmaster_port = $::soge::soge_qmaster_port,
  $_soge_service_name = $::soge::soge_service_name,
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
    "${_soge_path}/spool":
      ensure => directory,
      mode   => '0755',
      owner  => "${_soge_admin_user}",
      group  => "${_soge_admin_group}";
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
      content => template('soge/bootstrap.erb');
    "${_soge_path}/common/cluster_name" :
      ensure  => present,
      mode    => '0644',
      owner   => "${_soge_admin_user}",
      group   => "${_soge_admin_group}",
      content => "${_soge_cluster_name}";
    "${_soge_path}/common/settings.sh" :
      ensure  => present,
      mode    => '0644',
      owner   => "${_soge_admin_user}",
      group   => "${_soge_admin_group}",
      content => template('soge/settings.sh.erb');
    '/etc/profile.d/soge_settings.sh' :
      ensure  => link,
      target  => "${_soge_path}/common/settings.sh",
      require => File["${_soge_path}/common/settings.sh"];
    "${_soge_path}/common/sge_request" :
      ensure  => "${ensure_soge_request}",
      mode    => '0644',
      owner   => "${_soge_admin_user}",
      group   => "${_soge_admin_group}",
      content => template('soge/soge_request.erb');
  }

}
