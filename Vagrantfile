# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  
  config.vm.hostname = "fedora-stack-prod"

  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 6144 
    vb.cpus = 2
    config.vm.network "private_network", ip: "192.168.42.5"
    config.vm.network :forwarded_port, guest: 80, host: 4568
    config.ssh.forward_x11 = true
    # vb.gui = true
  end

  # sets shared dir that is passed to bootstrap
  shared_dir = "/vagrant"  

  config.vm.provision "shell", path: "./install_scripts/bootstrap.sh", args: shared_dir  
  config.vm.provision "shell", path: "./install_scripts/lamp.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/java.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/tomcat.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/varnish.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/solr.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/fedora.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/oaiprovider.sh", args: shared_dir  
  config.vm.provision "shell", path: "./install_scripts/supervisor.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/kakadu.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/rtail.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/ouroboros.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/front_end.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/loris.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/utilities.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/readux.sh", args: shared_dir
  
  config.vm.provision "shell", path: "./install_scripts/cleanup.sh", args: shared_dir

end
