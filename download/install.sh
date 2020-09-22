
masterdeploy=(etcd kube-apiserver kube-scheduler kube-controller-manager)
nodedeploy=(kube-proxy kubelet)

for serv in ${masterdeploy[@]}
do
ssh root@${MASTER_IP} "mkdir -p /opt/${serv}/{data,log}"
scp ./bin/${serv}  root@${MASTER_IP}:/opt/${serv}
done


for serv in ${nodedeploy[@]}
do
ssh root@${NODE_IP} "mkdir -p /opt/${serv}/{data,log}"
scp ./bin/${serv}  root@${NODE_IP}:/opt/${serv}
done

chmode +x bin/runc
ssh root@${NODE_IP} "mkdir -p /opt/containerd/{data,log}"
ssh root@${NODE_IP} "mkdir -p /opt/cni/bin /etc/cni/net.d"
scp bin/containerd/bin/* bin/runc bin/crictl root@${NODE_IP}:/opt/containerd/
scp bin/cni-plugins/* root@${NODE_IP}:/opt/cni/bin
