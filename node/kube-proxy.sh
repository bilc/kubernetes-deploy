cat <<EOF > ./kube-proxy-config.yaml
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "/opt/kube-proxy/kube-proxy.kubeconfig"
mode: "iptables"
clusterCIDR: "10.200.0.0/16"
EOF

cat <<EOF | sudo tee ./kube-proxy.service
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/opt/kube-proxy/kube-proxy \\
  --config=/opt/kube-proxy/kube-proxy-config.yaml \\
  --hostname-override=${NODE_IP}
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


scp kube-proxy-config.yaml root@${NODE_IP}:/opt/kube-proxy
scp kube-proxy.service root@${NODE_IP}:/etc/systemd/system/kube-proxy.service
ssh root@${NODE_IP} "systemctl daemon-reload && systemctl enable kube-proxy && systemctl restart kube-proxy " 
