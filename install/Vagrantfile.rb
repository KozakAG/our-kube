#Vagrant.configure(2) do |config|
#  config.vm.box = "bento/ubuntu-18.04"
#  config.vm.provision "shell", path: "provision.sh"
# end

BOX_IMAGE = "bento/ubuntu-20.04"
Vagrant.configure("2") do |config|
        config.vm.define "master" do |subconfig|
            subconfig.vm.provider "virtualbox" do |v|
                v.name = "master_vm"
            end
            subconfig.vm.box = BOX_IMAGE
            subconfig.vm.network "private_network", ip: "192.168.63.100"

            subconfig.vm.provider "virtualbox" do |vb|
                vb.memory = "2048"
                vb.cpus = "2"
            end
            #subconfig.vm.provision :shell, path: "test.sh"			
        end
		
		config.vm.define "node1" do |subconfig|
            subconfig.vm.provider "virtualbox" do |v|
                v.name = "node1_vm"
            end
            subconfig.vm.box = BOX_IMAGE
            subconfig.vm.network "private_network", ip: "192.168.63.200"

            subconfig.vm.provider "virtualbox" do |vb|
                vb.memory = "2048"
                vb.cpus = "2"
            end
            #subconfig.vm.provision :shell, path: "test.sh"
        end

        config.vm.define "node2" do |subconfig|
            subconfig.vm.provider "virtualbox" do |v|
                v.name = "node2_vm"
            end
            subconfig.vm.box = BOX_IMAGE
            subconfig.vm.network "private_network", ip: "192.168.63.50"

            subconfig.vm.provider "virtualbox" do |vb|
                vb.memory = "2048"
                vb.cpus = "2"
            end
            #subconfig.vm.provision :shell, path: "test.sh"
        end
    end