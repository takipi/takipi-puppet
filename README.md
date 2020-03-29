# takipi

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with takipi](#setup)
    * [What takipi affects](#what-takipi-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with takipi](#beginning-with-takipi)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Testing](#testing)
7. [Changelog](#chagelog)

## Overview

This module handles installation of Takipi agent.

Java agent currently supports RPM and DEB-based Linux distributions.
.Net agent currently supports Windows platform.

## Module Description

Takipi deploys a VM agent library and a daemon process (called collector and deployed only in Java agent installation) on your servers. These two components work in tandem to log and send data to Takipi's analysis servers. Together they detect events (such as exceptions or logged errors) happening within your app and automatically create the code needed to log and collect the data you'll need to debug these errors in production.

.Net agent requiers an installation of remote collector.

## Setup

### What takipi affects

Java agent:
* Installs Java on the node that Takipi is to be installed, handled by `puppetlabs-java` module. (optional)
* Installs Takipi base package.
* Adds the Takipi secret key (found under `/opt/takipi/work/secret.key`) and completes package installation.

.Net agent:
* Removes previous .Net agent.
* Downloads and installs an msi of the agent.

### Setup Requirements 

Requires;

* `puppetlabs-stdlib`         (puppet module install puppetlabs-stdlib)
* `puppetlabs-java <= 1.3.0`  (puppet module install puppetlabs-java --version 1.3.0)

### Beginning with takipi

Create your account at https://app.takipi.com/account.html and get your secret key.

For .Net Agent, please prepare remote collector (https://doc.overops.com/docs/install-a-collector-for-net)

## Usage

Basic usage of Java agent:

copy the takipi module to the puppet modules path (for example /etc/puppet/modules/takipi)
```

include takipi
class {'::takipi':
  secret_key => 'YOUR_SECRET_KEY',
}
```

Takipi with specific Java version:

distribution, will define the type of environment JRE or JDK
package, will represent the full packge name

```
class {'java':
  distribution          => 'jdk',
  package               => undef,
}
```
Takipi without external Java installation:

```
include takipi
class {'::takipi':
  manage_java => false,
  secret_key  => 'YOUR_SECRET_KEY',
}
```

Basic usage of .Net agent:

copy the takipi module to the puppet modules path (for example C:\Program Files\Puppet Labs\Puppet\puppet\modules\takipi)

```
include takipi
class {'::takipi':
    secret_key  => 'YOUR_SECRET_KEY',
    collector_host => 'YOUR_COLLECTOR_IP',
    collector_port => 'YOUR_COLLECTOR_PORT',
    windows_temp_dir => 'C:\users\Administrator\Downloads',
}

```

## Reference


## Limitations

Does not handle extra functionality apart from installing Takipi.

## Development

Pull requests are greatly appreciated, please keep proper indentation.

Beaker tests are awesome, feel free to throw some in.

### Testing

Under `tests/` there is a Vagrantfile that can be used to test Takipi module. Currently two boxes are added for tests, Centos 6.5 and Ubuntu 13.10 provided by Puppetlabs.

Make sure to add a valid secret key in `tests/manifests/takipi.pp`.

Usage:

`vagrant up takipi_centos`

`vagrant up takipi_ubuntu`

## Changelog

0.4.0 @pmoust - Initial Release

0.5.0 - 2017-07-04
### Added
- Java Class variables
- Config scripts to Vagrant folder
- Testing the module against CentOS 7, Ubuntu Trusty, Ubuntu Xenial

### Fixed
- Java Class declaration
- Support in verity of Distros
- takipi configuration

0.6.0 - 2020-03-24
### Added
- Support .Net agent installation on windows