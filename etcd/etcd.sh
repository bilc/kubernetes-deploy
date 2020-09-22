
export ETCD_NAME=etcd-0

cat <<EOF > ./etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
Type=notify
ExecStart=/opt/etcd/etcd \\
  --name ${ETCD_NAME} \\
  --trusted-ca-file=/opt/etcd/ca.pem \\
  --cert-file=/opt/etcd/etcd.pem \\
  --key-file=/opt/etcd/etcd-key.pem \\
  --peer-trusted-ca-file=/opt/etcd/ca.pem \\
  --peer-cert-file=/opt/etcd/etcd.pem \\
  --peer-key-file=/opt/etcd/etcd-key.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${MASTER_IP}:2380 \\
  --listen-peer-urls https://${MASTER_IP}:2380 \\
  --listen-client-urls https://${MASTER_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${MASTER_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster ${ETCD_NAME}=https://${MASTER_IP}:2380 \\
  --initial-cluster-state new \\
  --data-dir=/opt/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

scp etcd.service root@${MASTER_IP}:/etc/systemd/system/etcd.service
ssh root@${MASTER_IP} "systemctl daemon-reload && systemctl enable etcd && systemctl restart etcd " &

