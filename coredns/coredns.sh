git clone https://github.com/coredns/deployment.git
cd deployment/kubernetes
./deploy.sh -i ${CLUSTER_DNS_SVC_IP} -d ${CLUSTER_DNS_DOMAIN} | kubectl apply -f -


