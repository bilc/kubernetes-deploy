wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sed -i 's/quay.io/quay.mirrors.ustc.edu.cn/' kube-flannel.yml
sed -i 's/quay.io/quay.mirrors.ustc.edu.cn/' kube-flannel.yml

kubectl apply -f kube-flannel.yml
