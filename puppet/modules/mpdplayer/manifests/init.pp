class mpdplayer {
  package { 'mpd': }

  service { "mopidy.service":
    provider => systemd,
    ensure   => stopped,
    enable   => true,
  }

  # only without mopidy
  service { "mpd.service":
    provider => systemd,
    ensure   => stopped,
    enable   => true,
    require  => [ Package['mpd'] ],
  }

  package { '/etc/puppet/files/mpdplayer':
    ensure   => 'installed',
    provider => 'pip',
    require  => [ Package['mpd'] ],
  }

  # development
  exec { '/etc/puppet/files/mpdplayer':
    command => '/usr/bin/pip install /etc/puppet/files/mpdplayer --upgrade',
    require => Package['python-pip']
  }
}
