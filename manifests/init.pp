# == Class: takipi
#
# Full description of class takipi here.
#
# === Parameters
#
# Document parameters here.
#
# [*secret_key*]
#   Your Takipi secret key
#
# [*source*]
#   Foreign url to fetch Takipi from. This is optional
#
# === Examples
#
#  class { takipi:
#    secret_key => 'S6629#2DLDkn2jSvgkxTAx#nnYs7ti9czFYZsQV/H55iExBNSUhdDoSm63uQtKxzKP=#572a',
#  }
#
# === Authors
#
# Panagiotis Moustafellos <pmoust@gmail.com>
#
# === Copyright
#
# Copyright 2014 Takipi, Inc.
#
class takipi (
  $secret_key = 'YOUR_KEY',
  $source    = undef,
) {
  # Add java dependency, for more information on puppetlabs-java module
  # see https://github.com/puppetlabs/puppetlabs-java/blob/master/manifests/init.pp
  include 'java'
  Class['java'] -> Class['takipi']

  case $osfamily {

    'redhat', 'suse': { 
      if $source == undef {
        $pkg_url = 'https://app.takipi.com/app/download?t=rpm&s=puppet' 
      } else {
	$pkg_url = $source
	}
      package { 'takipi':
        ensure    => installed,
        source    => $pkg_url,
        provider  => rpm,
      }
    }

    'debian': { 
      if $source == undef {
        $pkg_url = 'https://app.takipi.com/app/download?t=deb&s=puppet' 
      } else { $pkg_url=$source}

      exec {'fetch takipi':
        command   => "/usr/bin/wget -q '${pkg_url}' -O /tmp/takipi.deb",
        creates   => '/tmp/takipi.deb',
        logoutput => true,
      } ->
      package { 'takipi':
        ensure    => installed,
        source    => '/tmp/takipi.deb',
        provider  => dpkg,
      }
    }

    default:  { fail("Unrecognized operating system for Takipi installation") }
  }
  ->
  exec { 'install takipi':
    cwd       => '/opt/takipi/etc',
    command   => "/bin/bash ./takipi-setup-package $secret_key",
    logoutput => true,
  }

}
