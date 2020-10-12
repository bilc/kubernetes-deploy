
cat > kubernetes-csr.json <<EOF
{
  "CN": "system:kubelet-api-admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },

  "names": [
    {
      "O": "system:kubelet-api-admin",
      "C": "china",
      "ST": "beijing",
      "L": "beijing",
      "OU": "CA"
    }
  ],
  "hosts": [
	"127.0.0.1",
    "${MASTER_IP}",
    "${CLUSTER_KUBERNETES_SVC_IP}",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local.",
    "kubernetes.default.svc.${CLUSTER_DNS_DOMAIN}."
  ]
}
EOF

cfssl gencert \
	-ca=ca.pem \
	-ca-key=ca-key.pem \
	-config=ca-config.json \
	-profile=kubernetes \
	kubernetes-csr.json | cfssljson -bare kubernetes

scp ./ca.pem  ./kubernetes.pem ./kubernetes-key.pem ./service-account.pem root@${MASTER_IP}:/opt/kube-apiserver
