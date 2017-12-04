class lighthttpd {
  package { ['lighttpd']: }

  service { "lighttpd":
    provider => systemd,
    ensure   => running,
    enable   => true,
    require  => [ Package['lighttpd'] ],
  }

  file { '/etc/lighttpd/lighttpd.conf':
    ensure  => file,
    path    => '/etc/lighttpd/lighttpd.conf',
    content => template("lighthttpd/lighttpd.conf.erb"),
    owner   => "root",
    group   => "root",
    mode    => "0644",
    notify  => [ Service['lighttpd'] ]
  }
}
