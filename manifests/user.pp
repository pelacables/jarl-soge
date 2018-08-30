# == Class: soge::user
#
# Class that add sgeadmin user /group
#
class soge::user (
  $_soge_admin_user     = $::soge::soge_admin_user,
  $_soge_admin_user_id  = $::soge::soge_admin_user_id,
  $_soge_admin_group    = $::soge::soge_admin_group,
  $_soge_admin_group_id = $::soge::soge_admin_group_id,
  $_sge_root            = $::soge::soge_root,
) {

  user { "${_soge_admin_user}":
    ensure     => 'present',
    uid        => "${_soge_admin_user_id}",
    home       => "${_sge_root}",
    managehome => false,
    gid        => "${_soge_admin_group_id}",
    require    => Group["${_soge_admin_group}"];
  }
  group { "${_soge_admin_group}":
    ensure => 'present',
    gid    => "${_soge_admin_group_id}",
  }

}
