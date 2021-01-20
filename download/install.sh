
tar -xvf etcd-v3.4.3-linux-amd64.tar.gz
tar -xzvf kubernetes-server-linux-amd64.tar.gz

#sudo cp cfssl_1.4.1_linux_amd64 /usr/local/bin/cfssl
#sudo cp cfssljson_1.4.1_linux_amd64 /usr/local/bin/cfssljson
#sudo cp cfssl-certinfo_1.4.1_linux_amd64 /usr/local/bin/cfssl-certinfo
#sudo cp kubernetes/server/bin/kubectl  /usr/local/bin/


mkdir bin
cp etcd-v3.4.3-linux-amd64/etcd* bin

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

chmod +x bin/runc
ssh root@${NODE_IP} "mkdir -p /opt/containerd/{data,log}"
ssh root@${NODE_IP} "mkdir -p /opt/cni/bin /etc/cni/net.d"
scp bin/containerd/bin/* bin/runc bin/crictl root@${NODE_IP}:/opt/containerd/
scp bin/cni-plugins/* root@${NODE_IP}:/opt/cni/bin
