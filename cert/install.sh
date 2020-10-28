set -e 

./ca.sh

./etcd.sh

./service-account.sh
./kube-apiserver.sh
./kube-controller-manager.sh

./kube-scheduler.sh
./kubelet.sh
./kube-proxy.sh

#serv=etcd
#scp ./ca.pem  ./etcd.pem ./etcd-key.pem root@${MASTER_IP}:/opt/${serv}

#serv=kube-apiserver
#scp ./ca.pem  ./kubernetes.pem ./kubernetes-key.pem ./service-account.pem root@${MASTER_IP}:/opt/${serv}

#serv=kube-controller-manager
#scp ./ca.pem  ./kube-controller-manager.kubeconfig  ./service-account-key.pem  ./ca-key.pem root@${MASTER_IP}:/opt/${serv}

#serv=kube-scheduler
#scp  ./kube-scheduler.kubeconfig  root@${MASTER_IP}:/opt/${serv}

#serv=kube-proxy
#scp ./kube-proxy.kubeconfig  root@${NODE_IP}:/opt/${serv}

#serv=kubelet
#scp ./ca.pem  ./${NODE_IP}.kubeconfig ./${NODE_IP}.pem ./${NODE_IP}-key.pem root@${NODE_IP}:/opt/${serv}
#
#rm -f *.json  *.csr *.pem
