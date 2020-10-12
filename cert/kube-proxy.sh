cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "O": "system:node-proxier",
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
	-profile=kubernetes \
	kube-proxy-csr.json | cfssljson -bare kube-proxy

kubectl config set-cluster kubernetes-the-hard-way \
	--certificate-authority=ca.pem \
	--embed-certs=true \
	--server=https://${MASTER_IP}:6443 \
	--kubeconfig=kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
	--client-certificate=kube-proxy.pem \
	--client-key=kube-proxy-key.pem \
	--embed-certs=true \
	--kubeconfig=kube-proxy.kubeconfig

kubectl config set-context default \
	--cluster=kubernetes-the-hard-way \
	--user=system:kube-proxy \
	--kubeconfig=kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig


scp ./kube-proxy.kubeconfig  root@${NODE_IP}:/opt/kube-proxy
