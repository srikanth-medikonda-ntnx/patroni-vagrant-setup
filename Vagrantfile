Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.box_version = "20190419.0.0"
  ENV["LC_ALL"]      = "en_US.UTF-8"
  config.vm.provider "virtualbox" do |vb|
     vb.gui = false
     vb.cpus = 2
     vb.memory = 1024
  end
  config.vm.provision "shell", privileged: true, path: "bootstrap.sh"
  config.vm.provision :reload
  config.vm.provision "shell", privileged: true, path: "post_restart.sh"
end
