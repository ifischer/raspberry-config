# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.provider :virtualbox do |vb|
      vb.name = "minime-server"
      vb.gui = false
  end

  config.vm.provision "shell", path: "files/install_puppet_latest.sh"

  config.vm.provision "puppet", :options => ["--debug --trace --verbose"] do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
  end

  config.vm.network "forwarded_port", guest: 6680, host: 6680
  config.vm.network "forwarded_port", guest: 5000, host: 5000

  config.vm.synced_folder "files", "/etc/puppet/files"

  config.vbguest.iso_path = "#{ENV['HOME']}/Downloads/VBoxGuestAdditions_5.2.1-118918.iso"
  config.vbguest.auto_update = false
end
