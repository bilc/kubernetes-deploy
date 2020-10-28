set -e

#wget https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl_1.4.1_linux_amd64
#wget https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssljson_1.4.1_linux_amd64
#wget https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl-certinfo_1.4.1_linux_amd64
#
#wget https://github.com/coreos/etcd/releases/download/v3.4.3/etcd-v3.4.3-linux-amd64.tar.gz
#wget  https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.18.0/crictl-v1.18.0-linux-amd64.tar.gz 
#wget  https://github.com/opencontainers/runc/releases/download/v1.0.0-rc91/runc.amd64 
#wget  https://github.com/containernetworking/plugins/releases/download/v0.8.6/cni-plugins-linux-amd64-v0.8.6.tgz 
#wget  https://github.com/containerd/containerd/releases/download/v1.3.6/containerd-1.3.6-linux-amd64.tar.gz 
#wget https://dl.k8s.io/v1.18.6/kubernetes-server-linux-amd64.tar.gz  


wget https://k8s-deploy.bj.bcebos.com/k8s/cfssl_1.4.1_linux_amd64
wget https://k8s-deploy.bj.bcebos.com/k8s/cfssljson_1.4.1_linux_amd64
wget https://k8s-deploy.bj.bcebos.com/k8s/cfssl-certinfo_1.4.1_linux_amd64

wget https://k8s-deploy.bj.bcebos.com/k8s/etcd-v3.4.3-linux-amd64.tar.gz
wget https://k8s-deploy.bj.bcebos.com/k8s/crictl-v1.18.0-linux-amd64.tar.gz 
wget https://k8s-deploy.bj.bcebos.com/k8s/runc.amd64 
wget https://k8s-deploy.bj.bcebos.com/k8s/cni-plugins-linux-amd64-v0.8.6.tgz 
wget https://k8s-deploy.bj.bcebos.com/k8s/containerd-1.3.6-linux-amd64.tar.gz 
wget https://k8s-deploy.bj.bcebos.com/k8s/kubernetes-server-linux-amd64.tar.gz  


tar -xvf etcd-v3.4.3-linux-amd64.tar.gz
tar -xzvf kubernetes-server-linux-amd64.tar.gz

sudo mv cfssl_1.4.1_linux_amd64 /usr/local/bin/cfssl
sudo mv cfssljson_1.4.1_linux_amd64 /usr/local/bin/cfssljson
sudo mv cfssl-certinfo_1.4.1_linux_amd64 /usr/local/bin/cfssl-certinfo
sudo mv kubernetes/server/bin/kubectl  /usr/local/bin/


mkdir bin
mv etcd-v3.4.3-linux-amd64/etcd* bin

cd kubernetes/server/bin
mv kube-scheduler kube-controller-manager kube-apiserver kubelet kube-proxy  ../../../bin
cd -



tar -zxvf crictl-v1.18.0-linux-amd64.tar.gz 
mv crictl bin/

mkdir bin/containerd
tar -zxvf containerd-1.3.6-linux-amd64.tar.gz -C bin/containerd

mkdir bin/cni-plugins
tar -zxvf cni-plugins-linux-amd64-v0.8.6.tgz -C bin/cni-plugins

mv runc.amd64 bin/runc

chmod +x /usr/local/bin/*
export PATH=/usr/local/bin:${PWD}:$PATH

