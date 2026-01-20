#!/bin/bash
set -e

if [ -z $1 ]; then
    echo "Type mster cluster node name"
    exit 1
fi

CONTEXT_NAME=$1

WORKER_SIZE=${2:-1}
echo "$CONTEXT_NAME workers are will be $WORKER_SIZE instance(s) increased"

MASTER_NAME=$(multipass ls | grep ^${CONTEXT_NAME}-master | awk '{print $1}')

if [ -z $MASTER_NAME ]; then
    echo "Not found master name[$1]"
    exit 1
fi

# NEXT_SIZE=$(( $(multipass ls | grep ${CONTEXT_NAME} | wc -l | awk '{print $1}') + 1 ))
CURRENT_SIZE=$(multipass ls | grep ^${CONTEXT_NAME}-worker | wc -l | awk '{print $1}')
CURRENT_SIZE=${CURRENT_SIZE:-0}

echo "current size is ${CURRENT_SIZE}"

IMAGE=$(multipass ls | grep ^${CONTEXT_NAME}-master | awk '{print $5}')
NETWORK_NAME=$(multipass networks | grep en0 | awk '{print $1}')
MASTER_IP=$(multipass exec ${CONTEXT_NAME}-master -- hostname -I | awk '{print $1}')
NODE_TOKEN=$(multipass exec ${CONTEXT_NAME}-master -- sudo cat /var/lib/rancher/k3s/server/node-token)
START_COUNT=$(( $CURRENT_SIZE + 1 ))
END_COUNT=$(( $WORKER_SIZE + $CURRENT_SIZE))

for i in $(seq $START_COUNT $END_COUNT); do
  cat > worker-${i}.yaml <<EOF
package_update: true
image: ${IMAGE}
packages:
  - curl
runcmd:
  - curl -sfL https://get.k3s.io | K3S_URL=https://${MASTER_IP}:6443 K3S_TOKEN=${NODE_TOKEN} sh -
EOF

  multipass launch --name ${CONTEXT_NAME}-worker${i} --cpus 2 --memory 2G --disk 10G --network ${NETWORK_NAME} --cloud-init worker-${i}.yaml
  rm -f ./worker-${i}.yaml
done

echo "All nodes created. Checking cluster state..."
multipass exec ${CONTEXT_NAME}-master -- sudo kubectl get nodes
