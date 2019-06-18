#!/bin/bash

. config.sh

TARGETS=( "$KUBE_MASTER_DNS" "$KUBE_NODE1_DNS" "$KUBE_NODE2_DNS" )
for TARGET in "${TARGETS[@]}"; do
  script="/tmp/$TARGET.sh"

  cat > $script << eof
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \\
   \$(lsb_release -cs) \\
   stable"
eof
  
  ssh $SERVER_USERNAME@$TARGET 'bash -s' < $script
done