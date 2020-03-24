# == Class: takipi
#
# Full description of class takipi here.
#
# === Parameters
#
# Document parameters here.
#
# [*secret_key*]
#   Required. Your Takipi secret key.
#
# [*source*]
#   Optional. Foreign url to fetch Takipi from.
#
# [*manage_java*]
#   Optional. Java agent only. Installs Java package.
#
# [*collector_host*]
#   Required. .Net agent only. IP of remote collector.
#
# [*collector_port*] - .NET agent only!
#   Required. .Net agent only. Port of remote collector. 
#
# [*windows_temp_dir*]
#   Optional. .Net agent only. Temporary directory for msi downloading.
#
# === Examples
#
# == Java agent example
#
#  class { takipi:
#    secret_key => 'S6629#2DLDkn2jSvgkxTAx#nnYs7ti9czFYZsQV/H55iExBNSUhdDoSm63uQtKxzKP=#572a',
#  }
#
# == .Net agent example
#
#  class { takipi:
#    secret_key => 'S6629#2DLDkn2jSvgkxTAx#nnYs7ti9czFYZsQV/H55iExBNSUhdDoSm63uQtKxzKP=#572a',
#    collector_host => '127.0.0.1',
#    collector_port => '6060',
#    windows_temp_dir => 'C:\Windows\Temp',
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
  $secret_key  = 'YOUR_KEY',
  $source      = undef,
  $manage_java = true,
  $collector_host = undef,
  $collector_port = undef,
  $windows_temp_dir  = 'C:\users\Administrator\Downloads',
) {
  
  case $facts['kernel'] {
    'Linux': {

      if str2bool("$manage_java") {
        # Add java dependency, for more information on puppetlabs-java module
        # see https://github.com/puppetlabs/puppetlabs-java/blob/master/manifests/init.pp
        class {'java':
           distribution          => 'jdk',
           package               => undef, # can be for example 'java-1.8.0-openjdk',
         }
      }

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
        command   => "/bin/bash ./takipi-setup-package ${secret_key}",
        logoutput => true,
        unless    => "/bin/grep -q ${secret_key} /opt/takipi/work/secret.key",
      }
        Class['java'] -> Class['takipi']
    }
    'Windows': {
      if ($collector_host == undef) or ($collector_port == undef) {
        fail("Collector host or port not provided")
      }

      exec { 'remove_overops':
        command => 'C:\Windows\System32\msiexec.exe /x {6EB3F996-C92A-4D30-BDA6-75A7B20029EE} /qn /norestart',
        returns => ['0','1605'], # 0-was removed, 1605-doesn't exist
      }

      if $source == undef {
        $pkg_url = 'https://app-takipi-com.s3.amazonaws.com/deploy/win/Takipi.msi' 
      } else {
        $pkg_url = $source
      }
  
      file { 'download_msi':
        ensure => file,
        path   => "${windows_temp_dir}/OverOps.msi",
        source => "$pkg_url",
      }

      package { 'install_overops':
        ensure          => installed,
        source          => "${windows_temp_dir}/OverOps.msi",
        install_options => [ '/qn', '/norestart', "SK=${$secret_key}", 'INSTALL_COLLECTOR=0', 'SUPPORT_DOT_NET=1', 'ENABLE_DUMPS=1', "COLLECTOR_HOST=${collector_host}", "COLLECTOR_PORT=${collector_port}"],
      }
    }
  }
}
