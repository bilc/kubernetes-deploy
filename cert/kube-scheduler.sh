cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "O": "system:kube-scheduler",
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
	kube-scheduler-csr.json | cfssljson -bare kube-scheduler

kubectl config set-cluster kubernetes-the-hard-way \
	--certificate-authority=ca.pem \
	--embed-certs=true \
	--server=https://${MASTER_IP}:6443 \
	--kubeconfig=kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
	--client-certificate=kube-scheduler.pem \
	--client-key=kube-scheduler-key.pem \
	--embed-certs=true \
	--kubeconfig=kube-scheduler.kubeconfig

kubectl config set-context default \
	--cluster=kubernetes-the-hard-way \
	--user=system:kube-scheduler \
	--kubeconfig=kube-scheduler.kubeconfig

kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig

scp  ./kube-scheduler.kubeconfig  root@${MASTER_IP}:/opt/kube-scheduler
