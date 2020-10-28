if [[ ! -e  ~/.ssh/id_rsa.pub ]]
then
ssh-keygen
fi

ssh-copy-id -f -i ~/.ssh/id_rsa.pub root@${MASTER_IP}
ssh-copy-id -f -i ~/.ssh/id_rsa.pub root@${NODE_IP}
