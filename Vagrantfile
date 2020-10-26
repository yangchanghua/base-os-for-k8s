IMAGE_NAME = "centos/7"
MASTERS_NUM = 1
MASTERS_CPU = 2 
MASTERS_MEM = 6048

NODES_NUM = 3
NODES_CPU = 1
NODES_MEM = 2048

IP_BASE = "192.168.50.10"

VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

Vagrant.configure("2") do |config|

    config.ssh.insert_key = false
    config.vm.box = IMAGE_NAME
    config.vm.network  "private_network", ip: IP_BASE
    config.vm.hostname = "centos7-k8s"
    config.vm.synced_folder  ".", "/vagrant", disabled: true

    config.vm.provider "virtualbox" do |v|
        v.name = "centos7-k8s"
        v.memory = MASTERS_MEM
        v.cpus = MASTERS_CPU
    end

    config.vm.provision "shell", path: "common.sh"
end
