cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:masters",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
	-ca=ca.pem \
	-ca-key=ca-key.pem \
	-config=ca-config.json \
	-profile=kubernetes \
	admin-csr.json | cfssljson -bare admin

kubectl config set-cluster kubernetes-the-hard-way \
	--certificate-authority=ca.pem \
	--embed-certs=true \
	--server=https://${MASTER_IP}:6443 \
	--kubeconfig=admin.kubeconfig

kubectl config set-credentials admin \
	--client-certificate=admin.pem \
	--client-key=admin-key.pem \
	--embed-certs=true \
	--kubeconfig=admin.kubeconfig

kubectl config set-context default \
	--cluster=kubernetes-the-hard-way \
	--user=admin \
	--kubeconfig=admin.kubeconfig

kubectl config use-context default --kubeconfig=admin.kubeconfig

mkdir ~/.kube
cp admin.kubeconfig ~/.kube/config
