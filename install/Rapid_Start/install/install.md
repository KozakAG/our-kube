#
# Install Calico[( with operator)](Calico_Setup.pdf)
### By manifest
```sh
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.15/manifests/calico.yaml

```

### Install tigera operator
```sh
kubectl create -f https://docs.projectcalico.org/archive/v3.16/manifests/tigera-operator.yaml
```
### Check operator status
```sh
kubectl get pods -n tigera-operator
```

### Install Calico network
```sh
cat <<EOF | kubectl apply -f -
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  calicoNetwork:
    containerIPForwarding: Enabled
    ipPools:
    - cidr: 10.16.4.0/24
      natOutgoing: Enabled
      encapsulation: None
EOF
```
> ### You can`t install Calico network if you set wrong CIDR. You set CIDR when create cluster with _kubeadm_. To get your CIDR:
```sh
kubectl cluster-info dump | grep  cluster-cidr
```

#
# Kubectl autocompletion
```sh
{
apt install bash-completion -y ;
echo 'alias k=kubectl' >> ~/.bashrc ;
echo 'alias wk="watch kubectl"' >> ~/.bashrc ;
echo "source <(kubectl completion bash | sed 's/kubectl/k/g')" >> ~/.bashrc ;
logout
}
```
#
# Install istio
>### demo - all cores features
>### default - best for production
```sh
# 1. install isitio getmesh distro cli
curl -sL https://istio.tetratelabs.io/getmesh/install.sh | bash 

# 2.
 istio verify-install
# 2.1 install istio 
 istioctl install --set profile=demo 
```

>### Label _istio-injection=enabled_ mean that istio will make his work in that namespace
```sh
kubectl label namespace test istio-injection=enabled
```

# 
# Install Terratest
### [terratest](https://amazicworld.com/testing-terraform-code-with-terratest-part-1/)
```sh
{
wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
sudo apt install golang-go go-dep -y
export GOPATH=$HOME/go
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
mkdir -p $GOPATH/src/terraform
cd  $GOPATH/src/terraform
dep init
}
```

# Install Docker-compose
```sh
{
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

}
```

# Install helm
```sh
{
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
}
```
# Install metalLB
### Be careful with IP Pools of NODES!!!!!!!!. 

###  install:
```sh
{
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.3/manifests/metallb.yaml
}
```
### Content of _config.yaml_ below:

```yaml
   apiVersion: v1
   kind: ConfigMap # points that it's external configuration of metallb-system
   metadata:
     namespace: metallb-system # namespace affected by ConfigMap
     name: config
   data:
     config: | # configuration part
       address-pools: # pool of allocated addresses
       - name: default
         protocol: layer2 # protocol to use
         addresses:
         - 192.168.45.10-192.168.45.15 # allocated pool of addresses OF NODES!!!!!! 
```