if ($hostname =~ /^radio/) {
  $default_user = "ifischer"
} else {
  $default_user = "vagrant"
}

#include stdlib
#include python
include system
include system::rebootcronjob
include lighthttpd
include lirc
include mopidy::server
include mopidy::plugins
include mopidy::client
include mopidy::monitor
# include mpdplayer
# include wifi
include mplayer
include mpv


$base_packages = [
  'vim',
  'python-pip',
  'python3-pip',
  'htop',
  'mpc',
  'cups'
]
package { $base_packages: }

$development_packages = [
  'ipython',
  'ipython3',
  'python-ipdb',
  'python3-ipdb',
  'git'
]
package { $development_packages: }

# Remove Desktop
package { ['ubuntu-mate-core', 'ubuntu-mate-desktop', 'brltty', 'brltty-x11']:
  ensure   => 'absent',
}
