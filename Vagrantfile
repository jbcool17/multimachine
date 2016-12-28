# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://manski.net/2016/09/vagrant-multi-machine-tutorial/
# Original bento box didn't work - Switched to trusty64
BOX_IMAGE = "ubuntu/trusty64"
NODE_COUNT = 2
MACHINES = ['development','production', 'staging']
Vagrant.configure("2") do |config|

  config.vm.define "development" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "development"
    subconfig.vm.network :private_network, ip: "192.168.56.100"
  end

  (1..NODE_COUNT).each do |i|
    config.vm.define "#{MACHINES[i]}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname = "#{MACHINES[i]}"
      subconfig.vm.network :private_network, ip: "192.168.56.#{i + 100}"
    end
  end
  
  # Install avahi on all machines
  config.vm.provision "shell", inline: <<-SHELL
    apt-get install -y avahi-daemon libnss-mdns
  SHELL
end
