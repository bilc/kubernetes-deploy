cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "O": "system:kube-controller-manager",
      "C": "china",
      "ST": "beijing",
      "L": "beijing",
      "OU": "CA"
    }
  ],
  "hosts": [
  "127.0.0.1",
  "${MASTER_IP}"
  ]
}
EOF

cfssl gencert \
	-ca=ca.pem \
	-ca-key=ca-key.pem \
	-config=ca-config.json \
	-profile=kubernetes \
	kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

kubectl config set-cluster kubernetes-the-hard-way \
	--certificate-authority=ca.pem \
	--embed-certs=true \
	--server=https://${MASTER_IP}:6443 \
	--kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
	--client-certificate=kube-controller-manager.pem \
	--client-key=kube-controller-manager-key.pem \
	--embed-certs=true \
	--kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-context default \
	--cluster=kubernetes-the-hard-way \
	--user=system:kube-controller-manager \
	--kubeconfig=kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig

scp ./ca.pem  ./kube-controller-manager.kubeconfig  ./service-account-key.pem  ./ca-key.pem root@${MASTER_IP}:/opt/kube-controller-manager
