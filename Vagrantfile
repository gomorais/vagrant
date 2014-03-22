
#Vagrant::Config.run do |config|
Vagrant.configure("2") do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  #config.vm.provider "virtualbox" do |v|
  #  v.name = "myBox"
  #end
  #config.vm.synced_folder "./../", "/project/"

  config.vm.network :private_network, ip: "192.168.33.10"
  #config.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true

  #config.vm.provision :shell, :path => "setup/bootstrap.sh"
  config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "./setup"
      puppet.manifest_file = "manifest.pp"
  end

end
