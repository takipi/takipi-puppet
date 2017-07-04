#!/bin/bash
echo $1 > /tmp/puppet_repo.txt 
rpm -Uvh $1
yum -y install puppet
puppet module install puppetlabs-stdlib
puppet module install puppetlabs-java --version 1.3.0
