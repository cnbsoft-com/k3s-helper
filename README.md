# k3s-helper
> k3s usecase를 정형화한 스크립트 프로젝트.
```bash
# 통합 CLI 도구
./k3s-helper create           # 대화형 모드로 실행 (이름, 이미지 등 선택)
./k3s-helper create -n demo   # 이름만 지정 (나머지는 기본값)
./k3s-helper vm create        # 범용 VM 생성 마법사 실행
```

## 프로젝트 개요
Multipass를 사용하여 로컬 환경에서 가볍게 K3s Kubernetes 클러스터를 생성하고 관리하기 위한 쉘 스크립트 모음입니다.
`k3s-helper` 스크립트 하나로 클러스터 생성, 워커 추가, 보안 설정을 모두 관리할 수 있습니다.

## 사용 방법

### 1. 클러스터 생성 (Create)
인자 없이 실행하면 **대화형 모드(Interactive Mode)**가 시작되어 클러스터 이름과 이미지를 선택할 수 있습니다.

```bash
# 대화형 모드 (추천)
./k3s-helper create

# 비대화형 모드 (Scripting용)
./k3s-helper create -n my-cluster --image 24.04 --workers 3 --cpu 4 --mem 4G
```

> **Tip**: `multipass find`를 통해 사용 가능한 Ubuntu 이미지를 자동으로 검색하여 선택할 수 있습니다.

### 2. 범용 VM 생성 (VM Create)
K3s 클러스터 외에 일반적인 개발용 Ubuntu VM도 쉽게 생성할 수 있습니다.
```bash
./k3s-helper vm create
# CPU, Memory, Disk, Mount Path 등을 대화형으로 입력받습니다.
```

### 3. 워커 노드 추가 (Add Worker)
운영 중인 클러스터에 워커 노드를 추가로 증설합니다.
```bash
./k3s-helper add-worker -n my-cluster -c 2
```

### 4. TLS SAN 설정 (TLS SAN)
외부에서 API 서버에 접근하기 위해 TLS SAN(Subject Alternative Name)을 추가하고 K3s를 재시작합니다.
```bash
./k3s-helper tls-san -n my-cluster -d example.com --apply
```
