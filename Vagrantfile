# -*- mode: ruby -*-
# vi: set ft=ruby :

box = "centos8"
boot_script = "bootstrap.sh"
default_ssh_key = "~/.vagrant.d/insecure_private_key"
local_sync_folder = "./ansible-init"
remote_sync_folder = "/home/vagrant/ansible-init"
vms = [
  {
    "hostname" => "ansible-master",
    "ip" => "192.168.66.200"
  },
  {
    "hostname" => "ansible-node1",
    "ip" => "192.168.66.201"
  },
  {
    "hostname" => "ansible-node2",
    "ip" => "192.168.66.202"
  }
]

Vagrant.configure("2") do |config|
  config.vm.box = box

  # ssh config
  config.ssh.insert_key = false

  # config.vm.provision "shell", inline: <<-SHELL
  #   mkdir ~/provision
  # SHELL
  # config.vm.provision "file", source: "./provision/*", destination: "~/provision" # 3
  # config.vm.provision "file", source: "~/.vagrant.d/insecure_private_key", destination: "~/.ssh/" # 3
  config.vm.provision "shell", path: boot_script
  config.vm.synced_folder local_sync_folder, remote_sync_folder

  config.vm.provider :virtualbox do |v|
    v.memory = 1024
    v.linked_clone = true
  end

  vms.each do |vm|
    if vm['hostname'] == 'ansible-master'
      config.vm.provision "file", source: default_ssh_key, destination: "~/.ssh/"
    end
    config.vm.define vm['hostname'] do |node|
      node.vm.network :private_network, ip: vm['ip'], bridge: 'vboxnet0'
      node.vm.hostname = vm['hostname']
    end
  end
end

