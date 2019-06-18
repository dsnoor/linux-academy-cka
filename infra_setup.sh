#!/bin/bash

. config.sh

## Function: setup for all servers
all_server_setup() {
  TARGETS=( "$KUBE_MASTER_DNS" "$KUBE_NODE1_DNS" "$KUBE_NODE2_DNS" )
  for TARGET in "${TARGETS[@]}"; do
    script="/tmp/common-$TARGET.sh"
  
    cat > $script << eof
# Add the Docker Repository on all three servers.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \\
   \$(lsb_release -cs) \\
   stable"

# Add the Kubernetes repository on all three servers.
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Install Docker, Kubeadm, Kubelet, and Kubectl on all three servers.
sudo apt-get update
sudo apt-get install -y \\
  docker-ce=18.06.1~ce~3-0~ubuntu \\
  kubelet=1.12.7-00 \\
  kubeadm=1.12.7-00 \\
  kubectl=1.12.7-00
sudo apt-mark hold docker-ce kubelet kubeadm kubectl

# Enable net.bridge.bridge-nf-call-iptables on all three nodes
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
eof
    
    ssh $SERVER_USERNAME@$TARGET 'bash -s' < $script
  done
}

## Function: setup for master server
master_setup() {
  TARGETS=( "$KUBE_MASTER_DNS")
  for TARGET in "${TARGETS[@]}"; do
    script="/tmp/master-$TARGET.sh"
  
    cat > $script << eof
# initialize the cluster and configure kubectl.
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p \$HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config
sudo chown \$(id -u):\$(id -g) \$HOME/.kube/config

# Install the flannel networking plugin in the cluster
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
eof
    
    ssh $SERVER_USERNAME@$TARGET 'bash -s' < $script
  done

}

all_server_setup
master_setup

# ask user to continue
echo "** Now, copy the `kubeadm join xx.xxx.xx.xx:6443 --token xxxx --discovery-token-ca-cert-hash xxx` and run on worker nodes"
echo "** Press any key to continue when done .."
read input

echo "Verify that the nodes are joined"
ssh $SERVER_USERNAME@$KUBE_MASTER_DNS 'kubectl get nodes'
