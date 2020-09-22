cat <<EOF > ./kube-controller-manager.service
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/opt/kube-controller-manager/kube-controller-manager \\
  --bind-address=0.0.0.0 \\
  --allocate-node-cidrs=true \\
  --cluster-cidr=${CLUSTER_CIDR} \\
  --cluster-name=kubernetes \\
  --cluster-signing-cert-file=/opt/kube-controller-manager/ca.pem \\
  --cluster-signing-key-file=/opt/kube-controller-manager/ca-key.pem \\
  --kubeconfig=/opt/kube-controller-manager/kube-controller-manager.kubeconfig \\
  --leader-elect=true \\
  --root-ca-file=/opt/kube-controller-manager/ca.pem \\
  --service-account-private-key-file=/opt/kube-controller-manager/service-account-key.pem \\
  --service-cluster-ip-range=${SERVICE_CIDR} \\
  --use-service-account-credentials=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


scp kube-controller-manager.service root@${MASTER_IP}:/etc/systemd/system/kube-controller-manager.service
ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable kube-controller-manager && systemctl restart kube-controller-manager " 
