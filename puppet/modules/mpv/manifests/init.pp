class mpv {
  package { 'libmpv1': }

  package { 'python-mpv':
    provider => 'pip',
  }
}

