#!/bin/sh
set -e -x

# Temporary work dir
tmpdir="`mktemp -d`"
cd "$tmpdir"

# Install prerequisites
export DEBIAN_FRONTEND=noninteractive
apt-get update -q --yes
apt-get install -q --yes logrotate vim-nox hardlink wget ca-certificates curl build-essential rsync libxml2-dev libxslt1-dev runit sudo mlocate

# Download and install Chef's packages
# Updated chef-server-core to latest
wget -nv https://packages.chef.io/files/stable/chef-server/12.17.33/ubuntu/16.04/chef-server-core_12.17.33-1_amd64.deb
# Updated chef-client to latest
wget -nv https://packages.chef.io/files/stable/chef/14.0.202/ubuntu/16.04/chef_14.0.202-1_amd64.deb

sha256sum -c - <<EOF
2800962092ead67747ed2cd2087b0e254eb5e1a1b169cdc162c384598e4caed5  chef-server-core_12.17.33-1_amd64.deb
469d2fc75501d2c1150210042351adacc8972398145d014add337315593b5920  chef_14.0.202-1_amd64.deb
EOF

dpkg -i chef-server-core_12.17.33-1_amd64.deb chef_14.0.202-1_amd64.deb

# Extra setup
rm -rf /etc/opscode
mkdir -p /etc/cron.hourly
ln -sfv /var/opt/opscode/log /var/log/opscode
ln -sfv /var/opt/opscode/etc /etc/opscode
ln -sfv /opt/opscode/sv/logrotate /opt/opscode/service
ln -sfv /opt/opscode/embedded/bin/sv /opt/opscode/init/logrotate
chef-apply -e 'chef_gem "knife-opc"'

# Cleanup
cd /
rm -rf $tmpdir /tmp/install.sh /var/lib/apt/lists/* /var/cache/apt/archives/*
