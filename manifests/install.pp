# == Class: soge::install
#
# Class that installs SoGE software
# Notice that the package has to be available in any of your repos.
# you can always use https://arc.liv.ac.uk/downloads/SGE/releases/8.1.9/
# but it is not a valid yum repository
#

class soge::install (
  $_package_name = $::soge::package_name,
  $_version      = $::soge::version,
) {

  if ($soge::manage_user) {
    include soge::user
  }

  package { "${::soge::package_name}":
    ensure => "${::soge::version}",
  }

}
