
cat << EOF | sudo tee containerd-config.toml
root = "/opt/containerd/data"
state = "/opt/containerd/state"
oom_score = 0
imports = ["/etc/containerd/runtime_*.toml", "./debug.toml"]

[grpc]
  address = "/run/containerd/containerd.sock"
  uid = 0
  gid = 0

[debug]
  address = "/run/containerd/debug.sock"
  uid = 0
  gid = 0
  level = "info"

[metrics]
  address = ""
  grpc_histogram = false

[cgroup]
  path = ""

[plugins]
  [plugins.cgroups]
    no_prometheus = false
  [plugins.cri]
    sandbox_image = "registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2"
  [plugins.diff]
    default = ["walking"]
  [plugins.linux]
    shim = "/opt/containerd/containerd-shim"
    runtime = "/opt/containerd/runc"
    runtime_root = ""
    no_shim = false
    shim_debug = false
  [plugins.scheduler]
    pause_threshold = 0.02
    deletion_threshold = 0
    mutation_threshold = 100
    schedule_delay = 0
    startup_delay = "100ms"
EOF


cat <<EOF > containerd.service
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
Environment="PATH=/opt/containerd:/bin:/sbin:/usr/bin:/usr/sbin"
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/opt/containerd/containerd --config=/opt/containerd/containerd-config.toml
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

scp containerd-config.toml root@${NODE_IP}:/opt/containerd
scp containerd.service root@${NODE_IP}:/etc/systemd/system/containerd.service

ssh root@${NODE_IP} "systemctl daemon-reload && systemctl enable containerd && systemctl restart containerd " 

cat << EOF | sudo tee crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF
scp crictl.yaml root@${NODE_IP}:/etc/crictl.yaml

