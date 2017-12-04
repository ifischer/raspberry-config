class system {
  exec { 'generate_locales':
    command => '/usr/sbin/locale-gen de_DE.UTF-8',
    unless  => '/bin/grep -c "^de_DE.UTF-8" /etc/locale.gen',
  }

  exec { 'systemd-reload':
    command     => 'systemctl daemon-reload',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }

  # if ($hostname =~ /^radio/) {
    # file_line { 'sudo_passwordless':
    #   path => "/etc/sudoers.d/$default_user",
    #   line => "$default_user ALL=(ALL) NOPASSWD: /usr/bin/pip install /etc/puppet/files/mopidyclient"
    # }
  # } else {
    # Fix Vagrant not being able to provision anymore
    # file_line { 'sudo_fix_vagrant':
    #   path => "/etc/sudoers.d/$default_user",
    #   line => 'vagrant ALL=(ALL) NOPASSWD: ALL',
    # }
  # }
}

class system::rebootcronjob {
  cron { 'reboot':
    command => '/sbin/reboot',
    user    => 'root',
    hour    => 4,
    minute  => 0,
  }
}