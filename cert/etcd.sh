set -x 
cat > etcd-csr.json <<EOF
{
  "CN": "etcd",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "O": "k8s",
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "OU": "opsnull"
    }
  ]
}
EOF

cfssl gencert -ca=ca.pem \
    -ca-key=ca-key.pem \
	-hostname=127.0.0.1,${MASTER_IP} \
    -config=ca-config.json \
    -profile=kubernetes etcd-csr.json | cfssljson -bare etcd

scp ./ca.pem  ./etcd.pem ./etcd-key.pem root@${MASTER_IP}:/opt/etcd
