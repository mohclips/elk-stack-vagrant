# -*- mode: ruby -*-
# vi: set ft=ruby :

ELK_VERSION=6

Vagrant.configure("2") do |config|
  config.vm.box = "puppetlabs/ubuntu-16.04-64-nocm"
####  config.vm.box = "bento/ubuntu-16.04" # does not work - scsi issues, read-only FS issues
####  config.vm.box = "ubuntu/xenial64" # same as above

  # port forwarding from host to guest
  config.vm.network "forwarded_port", guest: 5601, host: 5601
  config.vm.network "forwarded_port", guest: 9200, host: 9200
  config.vm.network "forwarded_port", guest: 9300, host: 9300
  # collectd
  config.vm.network "forwarded_port", guest: 25826, host: 25826

  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"

  # additional folders
  # share the host syslogs - as it is the central syslog server
  config.vm.synced_folder "/var/log/", "/vagrant_syslogs"

  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     #vb.gui = true
  
     # Customize the amount of memory on the VM:
     vb.memory = "4096"
     vb.cpus = "2"
     vb.name = "ELK-stack"
   end

  # upgrade the OS before we start 
  config.vm.provision "shell", :path => "upgrade-ubuntu.sh" # fix for naff grub interactive upgrade

  config.vm.provision "shell", :path => "install-ELK.sh"

end


