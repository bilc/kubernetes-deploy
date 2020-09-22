
cat <<EOF | sudo tee ./kube-scheduler.yaml
apiVersion: kubescheduler.config.k8s.io/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
        kubeconfig: "/opt/kube-scheduler/kube-scheduler.kubeconfig"
leaderElection:
        leaderElect: true
EOF

cat <<EOF | sudo tee ./kube-scheduler.service
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/opt/kube-scheduler/kube-scheduler \\
--config=/opt/kube-scheduler/kube-scheduler.yaml \\
--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

scp kube-scheduler.yaml  root@${MASTER_IP}:/opt/kube-scheduler
scp kube-scheduler.service root@${MASTER_IP}:/etc/systemd/system/kube-scheduler.service
ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable kube-scheduler && systemctl restart kube-scheduler " 
