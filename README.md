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

This module handles installation of JVM and Takipi agent.

Currently supports RPM and DEB-based Linux distributions.

## Module Description

Takipi installs a daemon process and a JVM agent library on your servers. These two components work in tandem to log and send data to Takipi's analysis servers. Together they detect events (such as exceptions or logged errors) happening within your app and automatically create the code needed to log and collect the data you'll need to debug these errors in production.


## Setup

### What takipi affects

* Installs Java on the node that Takipi is to be installed, handled by `puppetlabs-java` module. (optional)
* Installs Takipi base package.
* Adds the Takipi secret key (found under `/opt/takipi/work/secret.key`) and completes package installation.

### Setup Requirements 

Requires;

* `puppetlabs-stdlib`
* `puppetlabs-java`

### Beginning with takipi

Create your account at https://app.takipi.com/account.html and get your secret key.

## Usage

Basic usage:

```
include takipi
class {'::takipi':
  secret_key => 'YOUR_SECRET_KEY',
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

