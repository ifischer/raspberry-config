#!/bin/bash
wget https://apt.puppetlabs.com/puppet-release-xenial.deb
dpkg -i ./puppet-release-xenial.deb
apt-get update
apt-get install -y puppet-agent
ln -sf /opt/puppetlabs/bin/puppet /usr/bin/puppet
puppet module install puppetlabs-vcsrepo
puppet module install puppetlabs-stdlib
puppet module install stankevich-python
