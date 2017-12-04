class mplayer {
  package { 'mplayer': }

  package { 'mplayer.py':
    ensure   => 'installed',
    provider => 'pip',
    require  => [ Package['mplayer'] ],
  }
}
