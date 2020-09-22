cat <<EOF > ./kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/opt/kubelet/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "${CLUSTER_DNS_DOMAIN}"
clusterDNS:
  - "${CLUSTER_DNS_SVC_IP}"
runtimeRequestTimeout: "15m"
tlsCertFile: "/opt/kubelet/${NODE_IP}.pem"
tlsPrivateKeyFile: "/opt/kubelet/${NODE_IP}-key.pem"
EOF


cat <<EOF > ./kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/opt/kubelet/kubelet \\
  --config=/opt/kubelet/kubelet-config.yaml \\
  --container-runtime=remote \\
  --hostname-override=${NODE_IP}  \\
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=/opt/kubelet/${NODE_IP}.kubeconfig \\
  --register-node=true \\
  --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2 \\
  -v=5
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


scp kubelet-config.yaml root@${NODE_IP}:/opt/kubelet
scp kubelet.service root@${NODE_IP}:/etc/systemd/system/kubelet.service
ssh root@${NODE_IP} "systemctl daemon-reload && systemctl enable kubelet && systemctl restart kubelet " 
