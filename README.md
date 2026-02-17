# mpk3s - Multipass K3s Cluster Manager 🦖

[![License](https://img.shields.io/github/license/cnbsoft-com/k3s-helper)](https://github.com/cnbsoft-com/k3s-helper/blob/main/LICENSE)
[![Version](https://img.shields.io/github/v/release/cnbsoft-com/k3s-helper)](https://github.com/cnbsoft-com/k3s-helper/releases)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
![Language](https://img.shields.io/badge/language-shell-brightgreen)

> **AA Master's choice for rapid K8s infrastructure.**
> 로컬 환경에서 Multipass를 기반으로 K3s 클러스터를 광속으로 구축하고 관리하기 위한 통합 CLI 도구입니다. (An integrated CLI tool for rapidly building and managing K3s clusters on a local environment based on Multipass.)
>
> K3s에 대한 더 자세한 정보는 [공식 웹사이트](https://k3s.io)를 참조하십시오. (For more detailed information about K3s, please refer to the official website: [https://k3s.io](https://k3s.io))

## ⚠️ WARNING: For Development and Testing Only

**This project is strictly intended for local development and testing environments.** 
It is NOT designed or recommended for production use. The simplified security configurations and automated setups are optimized for developer productivity, not for high-availability or hardened production infrastructure.

## 🚀 Key Features

- **통합 CLI: (Integrated CLI:)** 모든 기능을 `mpk3s` 명령어 하나로 제어합니다. (Control all features with a single `mpk3s` command.)
- **자동 프로비저닝: (Automated Provisioning:)** Master와 다수의 Worker 노드를 사양에 맞춰 자동 생성 및 구성합니다. (Automatically create and configure Master and multiple Worker nodes according to specifications.)
- **멀티 클러스터 관리: (Multi-cluster Management:)** 여러 클러스터의 `kubeconfig`를 독립적으로 관리하고 환경 변수를 자동 최적화합니다. (Independently manage `kubeconfig` for multiple clusters and automatically optimize environment variables.)
- **보안 및 확장: (Security & Scalability:)** 외부 접속을 위한 TLS SAN 설정 및 동적 워커 노드 추가/삭제를 지원합니다. (Supports TLS SAN configuration for external access and dynamic addition/deletion of worker nodes.)

## 🛠 Prerequisites

- **macOS**
- **Multipass** installed ([https://multipass.run](https://multipass.run))
- **curl** (for K3s installation)

## Usage

### 1. 초기화 (Initialize)
멀티 클러스터 관리를 위한 kubeconfig 설정 스크립트를 생성합니다. (Generate a kubeconfig configuration script for multi-cluster management.)
```bash
mpk3s init
# 'source ~/.kube-config.sh' 명령을 .zshrc 등에 추가하세요. (Add the 'source ~/.kube-config.sh' command to your .zshrc, etc.)
```

### 2. 클러스터 생성 (Generate)
대화형 모드로 이름, 이미지, 사양을 선택하여 클러스터를 생성합니다. (Create a cluster by selecting name, image, and specs in interactive mode.)
```bash
mpk3s generate
```

### 3. 클러스터 관리 (Cluster Management)
```bash
mpk3s list        # 모든 클러스터 목록 확인 (ls 가능) (List all clusters - 'ls' also available)
mpk3s add         # 기존 클러스터에 워커 노드 추가 (Add worker nodes to an existing cluster)
mpk3s tls         # 마스터 노드에 TLS SAN 설정 추가 (Add TLS SAN configuration to the master node)
```

### 4. 노드 및 클러스터 삭제 (Deletion)
```bash
mpk3s delworker   # 특정 워커 노드 삭제 (Delete a specific worker node)
mpk3s delcluster  # 클러스터 전체 및 관련 설정 파일 완벽 삭제 (Complete deletion of the entire cluster and related configuration files)
```

## 🍺 Installation via Homebrew (Upcoming)

```bash
brew tap cnbsoft-com/tap
brew install mpk3s
```

## 📂 Project Structure

```text
k3s-helper/
├── bin/          # mpk3s 메인 실행 파일 (mpk3s main executable file)
├── libs/         # 핵심 기능을 담당하는 모듈화된 스크립트 (Modularized scripts for core features)
└── dev-logs/     # 일자별 개발 기록 및 결정 사항 (Daily development logs and decisions)
```

## 📄 License
This project is licensed under the **MIT License**.

---
*Developed with 🦖 by IK-YONG CHOI (AA Master)*
