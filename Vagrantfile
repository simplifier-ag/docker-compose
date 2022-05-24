# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"

  # config.vm.box_check_update = false

  config.vm.network "forwarded_port", guest: 8080, host: 8080

  config.vm.network "private_network", ip: "192.168.56.10"

  # config.vm.network "public_network"

  config.vm.synced_folder ".", "/runtime"

  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
    vb.memory = "8192"
  end

  config.vm.provision "shell", inline: <<-SHELL
     apt update
     apt install -y htop nmap joe vim git build-essential ca-certificates curl gnupg lsb-release
     curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
     echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
     apt update
     apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
     mkdir -p /var/lib/simplifier/mysql
     mkdir -p /var/lib/simplifier/data
     mkdir -p /etc/simplifier/traefik
   SHELL
end
