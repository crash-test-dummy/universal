# -*- mode: ruby -*-
# vi: set ft=ruby :

# Application definitions
app_name = "universal"
app_directory = "/home/vagrant/#{app_name}"

# Resource allocation
cpus = ENV["VM_CPUS"] || 2
ram = ENV["VM_RAM"] || 2048

# Node.js
nodejs_branch = "8"
nodejs_version = "8.11.3"

Vagrant.configure(2) do |config|

  config.vm.box = "inclusivedesign/fedora28"
  config.vm.hostname = app_name

  # Port-forwarding
  config.vm.network "forwarded_port", guest: 9081, host: 9081, protocol: "tcp", auto_correct: true # Preferences Server
  config.vm.network "forwarded_port", guest: 9082, host: 9082, protocol: "tcp", auto_correct: true # Flow Manager
  config.vm.network "forwarded_port", guest: 5984, host: 5984, protocol: "tcp", auto_correct: true # CouchDB

  # Shared folders
  config.vm.synced_folder ".", "#{app_directory}"

  # Mounts node_modules in /var/tmp to work around issues in the VirtualBox shared folders
  config.vm.provision "shell", run: "always", inline: <<-SHELL
    mkdir -p /var/tmp/#{app_name}/node_modules #{app_directory}/node_modules
    chown vagrant:vagrant -R /var/tmp/#{app_name}/node_modules #{app_directory}/node_modules
    mount -o bind /var/tmp/#{app_name}/node_modules #{app_directory}/node_modules
  SHELL

  # VirtualBox customizations
  config.vm.provider :virtualbox do |vm|
    vm.customize ["modifyvm", :id, "--memory", ram]
    vm.customize ["modifyvm", :id, "--cpus", cpus]
    vm.customize ["modifyvm", :id, "--vram", "256"]
    vm.customize ["modifyvm", :id, "--accelerate3d", "off"]
    vm.customize ["modifyvm", :id, "--audio", "null", "--audiocontroller", "ac97"]
    vm.customize ["modifyvm", :id, "--ioapic", "on"]
    vm.customize ["setextradata", "global", "GUI/SuppressMessages", "all"]
  end

  # Install system requirements
  config.vm.provision "shell", inline: <<-SHELL
    dnf install -y --disablerepo='*' https://rpm.nodesource.com/pub_#{nodejs_branch}.x/fc/28/x86_64/nodesource-release-fc28-1.noarch.rpm
    dnf install -y --repo=nodesource nodejs-#{nodejs_version}
  SHELL

  # Build application
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    echo "cd #{app_directory}" >> /home/vagrant/.bashrc
    npm install
  SHELL

end
