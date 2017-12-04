class lirc {
  $packages = [
    'lirc',
    'lirc-x',
    'liblircclient0',
    'inputlirc',
    'xmacro',
  ]
  package { $packages: }

  service { "lirc":
    provider => systemd,
    ensure   => running,
    enable   => true,
    require  => [ Package['lirc'] ],
  }

  file { '/etc/lirc/lircrc':
    ensure   => file,
    path     => '/etc/lirc/lircrc',
    source   => "puppet:///modules/lirc/lircrc",
    owner    => "root",
    group    => "root",
    mode     => "0644",
    backup   => true,
    notify   => [ Service['lirc'] ]
  }

  file { '/etc/lirc/hardware.conf':
    ensure   => file,
    path     => '/etc/lirc/hardware.conf',
    source   => "puppet:///modules/lirc/hardware.conf",
    owner    => "root",
    group    => "root",
    mode     => "0644",
    backup   => true,
    notify   => [ Service['lirc'] ]
  }

  file { '/etc/lirc/lircd.conf':
    ensure   => file,
    path     => '/etc/lirc/lircd.conf',
    source   => "puppet:///modules/lirc/lircd.conf",
    owner    => "root",
    group    => "root",
    mode     => "0644",
    backup   => true,
    notify   => [ Service['lirc'] ]
  }
}
