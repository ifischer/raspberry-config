class mopidy::server {
  # Use second interface on Raspberry
  if ($hostname =~ /^radio/) {
    $card_id = 1
  } else {
    $card_id = 0
  }

  package { ['mopidy', 'pulseaudio']: }

  # Set default output to analog
  file_line { 'pulse-default-sink':
    path => '/etc/pulse/default.pa',
    line => 'set-default-sink alsa_output.platform-sun4i-codec.analog-stereo',
  }

  # Lower CPU usage
  file_line { 'pulse-resample-trivial':
    path => '/etc/pulse/daemon.conf',
    line => 'resample-method = trivial',
    require => [ Package['pulseaudio'] ],
  }

  file { 'mopdiy.conf':
    ensure  => file,
    path    => '/etc/mopidy/mopidy.conf',
    content => template("mopidy/mopidy.conf.erb"),
    notify  => Service['mopidy.service'],
    require => [ Package['mopidy'] ],
    backup  => true
  }

  service { "mopidy.service":
    provider => systemd,
    ensure   => running,
    enable   => true,
    require  => [
      Package['mopidy'],
      File['/etc/mopidy/mopidy.conf'],
      File_line['pulse-resample-trivial']
    ],
  }

  file { 'radio.conf':
    ensure  => file,
    path    => '/etc/mopidy/radio.conf',
    source  => "puppet:///modules/mopidy/radio.conf",
    require => [ Package['mopidy'] ],
  }

  file { 'radio_streams.m3u8':
    ensure   => file,
    path     => '/var/lib/mopidy/playlists/[Radio Streams].m3u8',
    source   => "puppet:///modules/mopidy/radio_streams.m3u8",
    notify   => Service['mopidy.service'],
    require  => [ Package['mopidy'] ],
  }
}

class mopiyd::ppa {
  file { 'mopidy-sources.list':
    ensure  => file,
    path    => '/etc/apt/sources.list.d/mopidy.list',
    source => "puppet:///modules/mopidy/mopidy.list",
  }

  package { 'mopidy':
    require => [ File['mopidy-sources.list'] ],
  }
}


class mopidy::plugins {
  $mopidy_packages = [ 'Mopidy-MusicBox-Webclient', 'Mopidy-API-Explorer' ]

  package { $mopidy_packages:
    ensure   => 'installed',
    provider => 'pip',
    require  => [ Package['mopidy'] ],
    notify   => Service['mopidy.service'],
  }
}

class mopidy::client {
  # Client
# package { '/etc/puppet/files/mopidyclient':
#   ensure   => 'installed',
#   provider => 'pip',
#   require  => [ Package['mopidy'], Exec['generate_locales'] ],
#   notify   => Service['mopidy.service'],
# }

# vcsrepo { 'mopidy-source':
#   ensure   => latest,
#   provider => git,
#   source   => "git://github.com/mopidy/mopidy",
#   user     => "${default_user}",
#   path     => "/home/${default_user}/mopidy",
#   require  => Package['git']
# }
#
# exec { 'mopidy-editable':
#   command => "/usr/bin/pip install --editable /home/${default_user}/mopidy",
#   require => [ Vcsrepo['mopidy-source'] ],
# }
#
# exec { 'mopidyclient-editable':
#   command => '/usr/bin/pip install --editable /etc/puppet/files/mopidyclient',
# }

  # development
  exec { '/etc/puppet/files/mopidyclient':
    command => '/usr/bin/pip install /etc/puppet/files/mopidyclient --upgrade',
    require => Package['python-pip']
  }

}


class mopidy::monitor {
  file { '/etc/systemd/system/mopidy-monitor.timer':
    ensure => file,
    path   => '/etc/systemd/system/mopidy-monitor.timer',
    source => "puppet:///modules/mopidy/mopidy-monitor.timer",
    owner  => "root",
    group  => "root",
    mode   => "0644",
    notify => [ Exec['systemd-reload'] ]
  }

  file { '/etc/systemd/system/mopidy-monitor.service':
    ensure => file,
    path   => '/etc/systemd/system/mopidy-monitor.service',
    content => template("mopidy/mopidy-monitor.service.erb"),
    owner  => "root",
    group  => "root",
    mode   => "0644",

    notify => [ Service['mopidy-monitor.timer'], Exec['systemd-reload'], File['radio.conf'] ]
  }

  service { "mopidy-monitor.timer":
    provider => systemd,
    ensure   => running,
    enable   => true,
    require  => [
      File['/etc/systemd/system/mopidy-monitor.timer'],
      File['/etc/systemd/system/mopidy-monitor.service'],
    ],
  }
}
