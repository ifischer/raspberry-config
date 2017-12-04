class wifi {
  file { '/etc/network/interfaces':
    ensure  => file,
    path    => '/etc/network/interfaces',
    source   => "puppet:///modules/wifi/interfaces",
  }

  file { '/etc/NetworkManager/system-connections/mackaz2':
    ensure   => file,
    path     => '/etc/NetworkManager/system-connections/mackaz2',
    source   => "puppet:///modules/wifi/mackaz2",
    notify   => Service['network-manager'],
  }
}
