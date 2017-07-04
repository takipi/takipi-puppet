#!/bin/bash

function install_puppet_module () {
	puppet module list 2>/dev/null | grep -q $1 || puppet module install $@
}
apt-get -y install puppet

install_puppet_module  puppetlabs-stdlib
install_puppet_module puppetlabs-java --version 1.3.0
