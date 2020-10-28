. environment
ssh  root@${MASTER_IP} "systemctl stop   kube-apiserver.service  kube-controller-manager.service  kube-scheduler.service etcd.service"
ssh  root@${MASTER_IP} "rm -rf /opt/kube* /opt/etcd"
ssh  root@${NODE_IP} "systemctl stop kube-proxy.service  containerd.service kubelet.service"
ssh  root@${NODE_IP} "rm -rf /opt/kube* /opt/containerd  /opt/cni"

