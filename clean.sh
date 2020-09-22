. environment
ssh  root@${MASTER_IP} "systemctl stop   kube-apiserver.service  kube-controller-manager.service  kube-scheduler.service etcd.service"
ssh  root@${NODE_IP} "systemctl stop kube-proxy.service  kubelet.service"

