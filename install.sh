set -e 

. environment

cd download 
./download.sh
./install.sh
cd -

cd cert
./install.sh
cd -

cd etcd
./etcd.sh
cd -

cd master
./kube-apiserver.sh  
./kube-controller-manager.sh  
./kube-scheduler.sh
cd -

cd node
./containerd.sh  
./kube-proxy.sh  
./kubelet.sh
cd -

cd flannel
./flannel.sh
cd -

cd coredns
./coredns.sh
cd -
