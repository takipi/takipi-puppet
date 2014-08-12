#!/bin/sh
PUPPET_DIR=/etc/puppet/

$(which apt-get > /dev/null 2>&1)
FOUND_APT=$?
$(which yum > /dev/null 2>&1)
FOUND_YUM=$?

$(which git > /dev/null 2>&1)
FOUND_GIT=$?
if [ "$FOUND_GIT" -ne '0' ]; then
  echo 'Attempting to install git.'

  if [ "${FOUND_YUM}" -eq '0' ]; then
    yum -q -y makecache
    yum -q -y install git
    echo 'git installed.'
  elif [ "${FOUND_APT}" -eq '0' ]; then
    apt-get -q -y update
    apt-get -q -y install git
    echo 'git installed.'
  else
    echo 'No package installer available. You may need to install git manually.'
  fi
else
  echo 'git found.'
fi

if [ ! -d "$PUPPET_DIR" ]; then
  mkdir -p $PUPPET_DIR
fi

if [ ! -d $PUPPET_DIR/modules/stdlib ]; then
  git clone https://github.com/puppetlabs/puppetlabs-stdlib.git $PUPPET_DIR/modules/stdlib
fi
if [ ! -d $PUPPET_DIR/modules/java ]; then
  git clone https://github.com/puppetlabs/puppetlabs-java.git $PUPPET_DIR/modules/java
fi
