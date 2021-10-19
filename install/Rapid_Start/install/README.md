># [Source](https://github.com/justmeandopensource/kubernetes/tree/master/kubeadm-ha-multi-master) of this manual, Some configuration was cahnged!!! Becareful!!!
# Set up a Highly Available Kubernetes Cluster using kubeadm
Follow this documentation to set up a highly available Kubernetes cluster using __Ubuntu 20.04 LTS__.

This documentation guides you in setting up a cluster with two master nodes, one worker node and a load balancer node using HAProxy.

## Vagrant Environment
|Role|FQDN|IP|OS|RAM|CPU|
|----|----|----|----|----|----|
|Master|kmaster1.example.com|172.16.16.101|Ubuntu 20.04|4G|2|
|Worker|kworker1.example.com|172.16.16.201|Ubuntu 20.04|2G|2|
|Worker|kworker2.example.com|172.16.16.202|Ubuntu 20.04|2G|2|
> * Password for the **root** account on all these virtual machines is **kubeadmin**
> * Perform all the commands as root user unless otherwise specified
### You can ssh to instance by:
```sh
# 1 Master1 Node password(kubeadmin)
ssh root@localhost -p 2222

# 2 Worker1 Node password(kubeadmin)
ssh root@localhost -p 2200

# 2.1 Worker2 Node password(kubeadmin)
ssh root@localhost -p 2201
```
## Pre-requisites
If you want to try this in a virtualized environment on your workstation
* Virtualbox installed
* Vagrant installed
* Host machine has atleast 6 cores
* Host machine has atleast 8G memory

## Bring up all the virtual machines
```
# 1 Wake up nodes --parallel
vagrant up 

# 2 Shutdown nodes
vagrant halt
```



## On all kubernetes nodes (kmaster1, kmaster2, kworker1)
##### Disable Firewall
```
ufw disable
```
##### Disable swap
```
swapoff -a; sed -i '/swap/d' /etc/fstab
```
##### Update sysctl settings for Kubernetes networking
```
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```
##### Install docker engine
```
{
  apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt update && apt install -y docker-ce=5:19.03.10~3-0~ubuntu-focal containerd.io
}
```
### Kubernetes Setup
##### Add Apt repository
```
{
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
}
```
##### Install Kubernetes components
```
apt update && apt install -y kubeadm=1.19.2-00 kubelet=1.19.2-00 kubectl=1.19.2-00
```
## On any one of the Kubernetes master node (Eg: kmaster1)
##### Initialize Kubernetes Cluster
```
kubeadm init --apiserver-advertise-address=172.16.16.101 --pod-network-cidr=10.16.4.0/16
```
Copy the commands to join other master nodes and worker nodes.


## Join other nodes to the cluster (kworker1 & kworker2)
> Use the respective kubeadm join commands you copied from the output of kubeadm init command on the first master.

> IMPORTANT: You also need to pass --apiserver-advertise-address to the join command when you join the other master node.

## Downloading kube config to your local machine
On your host machine
```
mkdir ~/.kube
scp root@172.16.16.101:/etc/kubernetes/admin.conf ~/.kube/config
```
Password for root account is kubeadmin (if you used my Vagrant setup)

## On master
```
kubectl get nodes
mkdir ~/.kube/
cp /etc/kubernetes/admin.conf ~/.kube/config
```

Have Fun!!
Then go [here](install.md).