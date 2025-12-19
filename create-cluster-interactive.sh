#!/bin/sh

# k3s 클러스터 생성 스크립트
set -e

# Cleanup
cleanup() {
  echo "임시 생성 파일 정리"
  rm -rf ./master.yaml ./worker-*.yaml ./k3s-tls-san-*.yaml
}

trap cleanup EXIT ERR

usage() {
    echo "Usage: $0 <context_name> [worker_size] [options]"
    echo ""
    echo "Arguments:"
    echo "  context_name    : Required. Name for the cluster context"
    echo "  worker_size     : Optional. Number of worker nodes (default: 2)"
    echo ""
    echo "Environment Variables:"
    echo "  MASTER_CPU      : Master node CPU cores (default: 2)"
    echo "  MASTER_MEM      : Master node memory (default: 2G)"
    echo "  MASTER_DISK     : Master node disk size (default: 10G)"
    echo "  WORKER_CPU      : Worker node CPU cores (default: 2)"
    echo "  WORKER_MEM      : Worker node memory (default: 2G)"
    echo "  WORKER_DISK     : Worker node disk size (default: 10G)"
    echo "  INSTALL_K3S_EXEC: Additional k3s installation options"
    echo ""
    echo "Example:"
    echo "  $0 my-cluster 3"
    echo "  MASTER_CPU=4 MASTER_MEM=4G $0 my-cluster 2"
    exit 1
}

if [ -z $1 ]; then
    echo "Error: Context name is required"
    usage
fi

CONTEXT_NAME=$1
WORKER_SIZE=${2:-2}
IMAGE=

NETWORK_NAME=$(multipass networks | grep en0 | awk '{print $1}')
set -e


# --- ADD: Multipass 이미지 선택 및 multipass 래퍼 ---

# 사용자가 IMAGE/MULTIPASS_IMAGE를 미지정 시 인터랙티브로 이미지 선택
select_multipass_image() {
  # 우선순위: IMAGE > MULTIPASS_IMAGE > 인터랙티브 선택
  if [ -n "${IMAGE}" ]; then
    echo "Multipass image preset by IMAGE: ${IMAGE}"
    return 0
  fi

  if [ -n "${MULTIPASS_IMAGE}" ]; then
    IMAGE="${MULTIPASS_IMAGE}"
    echo "Multipass image preset by MULTIPASS_IMAGE: ${IMAGE}"
    return 0
  fi

  # 기본값 설정 및 비강제 모드에서는 바로 기본값 사용
  DEFAULT_IMAGE="24.04"
  if [ -z "${FORCE_IMAGE_SELECT}" ]; then
    IMAGE="${DEFAULT_IMAGE}"
    echo "Multipass image defaulted to: ${IMAGE} (set FORCE_IMAGE_SELECT=1 to choose)"
    return 0
  fi

  # 후보 이미지 검색 (ubuntu 계열 우선: 24.04/22.04 등)
  echo "Multipass 이미지 목록을 검색합니다..."
  IMAGES="$(command multipass find 2>/dev/null \
    | awk 'NR>1 {print $1}' \
    | grep -E '^[0-9]{2}\.[0-9]{2}$' \
    | sort -u)"


  if [ -z "${IMAGES}" ]; then
    echo "이미지 목록을 가져오지 못했습니다. 기본값(${DEFAULT_IMAGE})을 사용합니다."
    IMAGE="${DEFAULT_IMAGE}"
    return 0
  fi

  echo "사용할 이미지를 선택하세요:"
  printf "%s\n" ${IMAGES} | nl -w2 -s'. '
  echo "  c. 직접 입력 (custom)"

  while :; do
    printf "번호를 입력하세요 (기본: %s): " "${DEFAULT_IMAGE}"
    read ans
    case "${ans}" in
      "" )
        IMAGE="${DEFAULT_IMAGE}"
        break
        ;;
      c|C )
        printf "이미지 이름을 입력하세요 (예: 24.04): "
        read custom
        if [ -n "${custom}" ]; then
          IMAGE="${custom}"
          break
        fi
        ;;
      * )
        # 숫자 선택 처리
        if echo "${ans}" | grep -Eq '^[0-9]+$'; then
          choice="$(printf "%s\n" ${IMAGES} | sed -n "${ans}p")"
          if [ -n "${choice}" ]; then
            IMAGE="${choice}"
            break
          fi
        fi
        ;;
    esac
    echo "유효하지 않은 입력입니다. 다시 시도하세요."
  done

  echo "선택된 이미지: ${IMAGE}"
  return 0
}

# multipass 서브커맨드 래퍼: launch 시 자동으로 이미지를 첫 번째 인자로 삽입
multipass() {
  if [ "$1" = "launch" ]; then
    if [ -n "${IMAGE}" ]; then
      # --image 옵션이 있으면 제거하고 이미지를 첫 번째 인자로 추가
      ARGS=()
      SKIP_NEXT=false
      for arg in "${@:2}"; do
        if [ "${SKIP_NEXT}" = "true" ]; then
          SKIP_NEXT=false
          continue
        fi
        if [ "$arg" = "--image" ]; then
          SKIP_NEXT=true
          continue
        fi
        ARGS+=("$arg")
      done
      command multipass launch "${IMAGE}" "${ARGS[@]}"
      return $?
    fi
  fi
  command multipass "$@"
}
# --- END ADD ---

echo "Context name: ${CONTEXT_NAME}"
echo "NETWORK_NAME name: ${NETWORK_NAME}"
echo "WORKER SIZE: $WORKER_SIZE"

# Multipass 이미지 선택 (환경변수 없으면 인터랙티브)
select_multipass_image
echo "Multipass image: ${IMAGE}"

echo "Launching master node..."

## 예시 1: etcd + flannel (기본 vxlan)
### curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--cluster-init" sh -
## 예시 2: etcd + flannel 제거 + Calico를 직접 설치할 준비
### curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--cluster-init --flannel-backend=none --disable-network-policy" sh -
### curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--cluster-init --disable=traefik" sh -
# traefik 비활성화 (Istio 사용을 위해)
if [ -z "${INSTALL_K3S_EXEC}" ]; then
  INSTALL_K3S_EXEC="--cluster-init --disable=traefik"
else
  INSTALL_K3S_EXEC="--cluster-init --disable=traefik ${INSTALL_K3S_EXEC}"
fi

echo "INSTALL_K3S_EXEC is ${INSTALL_K3S_EXEC}"

cat > master.yaml <<EOF
package_update: true
packages:
  - curl
runcmd:
  - curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="${INSTALL_K3S_EXEC}" sh -
  - mkdir -p /etc/k3s
EOF


multipass launch --name ${CONTEXT_NAME}-master --cpus 2 --memory 2G --disk 10G --network ${NETWORK_NAME} --cloud-init master.yaml

rm -f ./master.yaml

echo "Initializing k3s..."

MASTER_IP=$(multipass exec ${CONTEXT_NAME}-master -- hostname -I | awk '{print $1}')
NODE_TOKEN=$(multipass exec ${CONTEXT_NAME}-master -- sudo cat /var/lib/rancher/k3s/server/node-token)

for i in $(seq 1 $WORKER_SIZE); do
  cat > worker-${i}.yaml <<EOF
package_update: true
packages:
  - curl
runcmd:
  - curl -sfL https://get.k3s.io | K3S_URL=https://${MASTER_IP}:6443 K3S_TOKEN=${NODE_TOKEN} sh -
EOF
  echo "Launching ${i} worker node"
  multipass launch --name ${CONTEXT_NAME}-worker${i} --cpus 2 --memory 2G --disk 10G --network ${NETWORK_NAME} --cloud-init worker-${i}.yaml
  rm -f ./worker-${i}.yaml
done


echo "All nodes created. Checking cluster state..."

multipass exec ${CONTEXT_NAME}-master -- sudo kubectl get nodes

echo "Generate k8s config file"
# multipass exec ${CONTEXT_NAME}-master -- sudo cat /etc/rancher/k3s/k3s.yaml | sed -e "s/127.0.0.1/$MASTER_IP/g" -e "s/cluster:\ default/cluster:\ ${CONTEXT_NAME}-cluster/g" -e "s/default/${CONTEXT_NAME}-context/g" > $HOME/.kube/config-${CONTEXT_NAME}
multipass exec ${CONTEXT_NAME}-master -- sudo cat /etc/rancher/k3s/k3s.yaml | sed -e "s/127.0.0.1/$MASTER_IP/g" -e "s/default/${CONTEXT_NAME}-context/g" > $HOME/.kube/config-${CONTEXT_NAME}

echo "Add following message you're KUBECONFIG env."
echo "\$HOME/.kube/config-${CONTEXT_NAME}"
