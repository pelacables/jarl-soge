# == Class: soge
#
# This is the main class for the SoGE puppet module.
# The RPM has to be already available in the system
#
# === Parameters
#
# [*version*]
#   SoGE version.
# [*package_name*]
#   Name of the rpm package that you want to install. (default to gridengine)
# [*soge_root*]
#   Base directory of the Son of Grid Engine installation. (default to /opt/soge)
# [*soge_cell*]
#   Name of the Son of Grid Engine cell to be installed. (Default to default)
# [*soge_cluster_name*]
#   Name of the Son of Grid Engine cluster to be installed. (Default to cluster1)
# [*soge_qmaster_port*]
#   Port number for the soge_qmaster daemon. (default to 6444)
# [*soge_execd_port*]
#   Port number for the soge_execd daemon. (default to 6445)
# [*soge_qmaster_name*]
#   FQDN of the node running as master host. (default to masterhost)
# [*manage_user*]
#   Attemp to create soge admin user. (default to true)
# [*soge_admin_user*]
#   Username for the soge admin user. (default to sogeadmin)
# [*soge_admin_user_id*]
#   uid for the username of the soge admin user. (default to 398)
# [*soge_admin_group*]
#   Groupname for the soge admin user. (default to sogeadmin)
# [*soge_admin_group_id*]
#   gid for the groupname of the soge admin user. (default to 399)
# [*soge_arch*]
#   arch for the binaries of the soge. (default to lx-amd64)
# [*manage_service*]
#   Attempt to install sogeexecd as system service. (default to true)
# [*soge_request*]
#   Array of parameters for creating a system soge_request. (default to undef)
# [*soge_node_type*]
#   soge node type of the target node. (default to execution. Only submit/execution supported).
# === Examples
#
#  class { 'soge':
#    version  => '8.1.9',
#    soge_cell => 'mycell',
#  }
#
# === Authors
#
# Arnau Bria. arnau.bria at gmail.com
#
# === Copyright
#
# Copyright 2018 Arnau Bria
#

class soge (
  String                     $version             = '8.1.9',
  Stdlib::Unixpath           $soge_root           = '/opt/soge',
  String                     $soge_cell           = 'default',
  String                     $soge_cluster_name   = 'condemor',
  Stdlib::Port::Unprivileged $soge_qmaster_port   = 6444,
  Stdlib::Port::Unprivileged $soge_execd_port     = 6445,
  Stdlib::Fqdn               $soge_qmaster_name   = 'gromenauer',
  Boolean                    $manage_user         = 'sogeadmin',
  String                     $soge_admin_user     = 398,
  Integer                    $soge_admin_user_id  = 398,
  String                     $soge_admin_group    = 'sogeadmin',
  Integer                    $soge_admin_group_id = '398',
  String                     $soge_arch           = 'lx-arch',
  Boolean                    $manage_service      = true,
  String                     $package_name        = gridengine,
  String                     $node_type           = undef,
  Option[Hash]               $soge_request        = undef,
) {

  contain 'soge::install'
  contain 'soge::configure'
  contain 'soge::service'

  class { 'soge::install' : }
  -> class { 'soge::configure' : }
  ~> class { 'soge::service' : }

}
