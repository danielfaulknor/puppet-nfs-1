# == Class: nfs::server::config
#
# This class exists to
#  1. configure nfs as a server
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Daniel Klockenkaemper <mailto:dk@marketing-factory.de>
#

class nfs::server::config {

  concat { '/etc/exports':
    ensure  => present,
  }

  concat::fragment { 'nfs_exports_header':
    target  => '/etc/exports',
    content => "# This file is configured through the nfs::server puppet module\n",
    order   => 1;
  }

  if $::nfs::nfs_v4 {
    concat::fragment { 'nfs_exports_root':
      target  => '/etc/exports',
      content => "${::nfs::server::nfs_v4_export_root} ${::nfs::server::nfs_v4_export_root_clients}\n",
      order   => 2,
    }
    file { $::nfs::server::nfs_v4_export_root:
      ensure => directory,
    }

    augeas { $::nfs::idmapd_file:
      context => "/files/${::nfs::idmapd_file}/General",
      lens    => 'Puppet.lns',
      incl    => $::nfs::idmapd_file,
      changes => ["set Domain ${::nfs::server::nfs_v4_idmap_domain}"],
    }

   
  }
}
