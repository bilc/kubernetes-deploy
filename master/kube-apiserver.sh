
export DIR=/opt/kube-apiserver

ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

cat  >  kube-apiserver.service <<EOF 
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=${DIR}/kube-apiserver \\
  --advertise-address=${MASTER_IP} \\
  --allow-privileged=true \\
  --apiserver-count=3 \\
  --audit-log-maxage=30 \\
  --audit-log-maxbackup=3 \\
  --audit-log-maxsize=100 \\
  --audit-log-path=${DIR}/log/audit.log \\
  --authorization-mode=Node,RBAC \\
  --bind-address=0.0.0.0 \\
  --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
  --etcd-cafile=${DIR}/ca.pem \\
  --etcd-certfile=${DIR}/kubernetes.pem \\
  --etcd-keyfile=${DIR}/kubernetes-key.pem \\
  --etcd-servers=https://${MASTER_IP}:2379 \\
  --event-ttl=1h \\
  --encryption-provider-config=${DIR}/encryption-config.yaml \\
  --kubelet-certificate-authority=${DIR}/ca.pem \\
  --kubelet-client-certificate=${DIR}/kubernetes.pem \\
  --kubelet-client-key=${DIR}/kubernetes-key.pem \\
  --kubelet-https=true \\
  --runtime-config=api/all=true \\
  --service-account-key-file=${DIR}/service-account.pem \\
  --service-cluster-ip-range=${SERVICE_CIDR} \\
  --service-node-port-range=${NODE_PORT_RANGE} \\
  --client-ca-file=${DIR}/ca.pem \\
  --tls-cert-file=${DIR}/kubernetes.pem \\
  --tls-private-key-file=${DIR}/kubernetes-key.pem \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

scp encryption-config.yaml root@${MASTER_IP}:$DIR
scp kube-apiserver.service root@${MASTER_IP}:/etc/systemd/system/kube-apiserver.service
ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable kube-apiserver && systemctl restart kube-apiserver " 
