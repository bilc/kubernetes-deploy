
cat > ${NODE_IP}-csr.json <<EOF
{
  "CN": "system:node:${NODE_IP}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "O": "system:nodes",
      "C": "china",
      "ST": "beijing",
      "L": "beijing",
      "OU": "CA"
    }
  ]
}
EOF


cfssl gencert \
	-ca=ca.pem \
	-ca-key=ca-key.pem \
	-config=ca-config.json \
	-hostname=${NODE_IP} \
	-profile=kubernetes \
	${NODE_IP}-csr.json | cfssljson -bare ${NODE_IP}

kubectl config set-cluster kubernetes-the-hard-way \
	--certificate-authority=ca.pem \
	--embed-certs=true \
	--server=https://${MASTER_IP}:6443 \
	--kubeconfig=${NODE_IP}.kubeconfig

kubectl config set-credentials system:node:${NODE_IP} \
	--client-certificate=${NODE_IP}.pem \
	--client-key=${NODE_IP}-key.pem \
	--embed-certs=true \
	--kubeconfig=${NODE_IP}.kubeconfig

kubectl config set-context default \
	--cluster=kubernetes-the-hard-way \
	--user=system:node:${NODE_IP} \
	--kubeconfig=${NODE_IP}.kubeconfig

kubectl config use-context default --kubeconfig=${NODE_IP}.kubeconfig


scp ./ca.pem  ./${NODE_IP}.kubeconfig ./${NODE_IP}.pem ./${NODE_IP}-key.pem root@${NODE_IP}:/opt/kubelet
