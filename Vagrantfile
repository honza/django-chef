require 'json'


# Load node.json
f = File.new 'node.json'
s = f.read
f.close

j = JSON.load s


Vagrant::Config.run do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.customize ["modifyvm", :id, "--memory", 256]

  config.vm.forward_port 80, 8844
  config.vm.forward_port 9999, 9999

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "deploy/cookbooks"
    chef.add_recipe "djangoapp::default"
    chef.json = j
  end

end
