#!/bin/bash

# include config
. config.sh

# ssh to the instance
TARGET=$1
DNS=""

if [ "$TARGET" == "master" ]; then
  DNS="$KUBE_MASTER_DNS"
elif [ "$TARGET" == "node1" ]; then
  DNS="$KUBE_NODE1_DNS"
elif [ "$TARGET" == "node2" ]; then
  DNS="$KUBE_NODE2_DNS"
fi

if [ -z "$DNS" ]; then
  echo "Please entre the target to ssh: master / node1 / node2"
  exit 1
fi

ssh $SERVER_USERNAME@$DNS