set -e 
set -x

./ca.sh

./etcd.sh

./service-account.sh
./kube-apiserver.sh
./kube-controller-manager.sh

./kube-scheduler.sh
./kubelet.sh
./kube-proxy.sh

