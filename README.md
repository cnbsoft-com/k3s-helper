# mpk3s - Multipass K3s Cluster Manager 🦖

> **AA Master's choice for rapid K8s infrastructure.**
> 로컬 환경에서 Multipass를 기반으로 K3s 클러스터를 광속으로 구축하고 관리하기 위한 통합 CLI 도구입니다.

## 🚀 Key Features

- **통합 CLI:** 모든 기능을 `mpk3s` 명령어 하나로 제어합니다.
- **자동 프로비저닝:** Master와 다수의 Worker 노드를 사양에 맞춰 자동 생성 및 구성합니다.
- **Auditor 특화 모드:** `mpk3s auditor` 명령으로 검증된 최적 사양의 클러스터를 즉시 구축합니다.
- **멀티 클러스터 관리:** 여러 클러스터의 `kubeconfig`를 독립적으로 관리하고 환경 변수를 자동 최적화합니다.
- **보안 및 확장:** 외부 접속을 위한 TLS SAN 설정 및 동적 워커 노드 추가/삭제를 지원합니다.

## 🛠 Prerequisites

- **macOS / Linux**
- **Multipass** installed ([https://multipass.run](https://multipass.run))
- **curl** (for K3s installation)

## 💻 Usage

### 1. 초기화 (Initialize)
멀티 클러스터 관리를 위한 kubeconfig 설정 스크립트를 생성합니다.
```bash
mpk3s init
# 'source ~/.kube-config.sh' 명령을 .zshrc 등에 추가하세요.
```

### 2. 클러스터 생성 (Generate)
대화형 모드로 이름, 이미지, 사양을 선택하여 클러스터를 생성합니다.
```bash
mpk3s generate
```

### 3. AA Auditor 전용 클러스터 생성 (Auditor)
마스터의 최적 권장 사양(Master 1, Worker 2)으로 즉시 구축합니다.
```bash
mpk3s auditor
```

### 4. 클러스터 관리
```bash
mpk3s list        # 모든 클러스터 목록 확인 (ls 가능)
mpk3s add         # 기존 클러스터에 워커 노드 추가
mpk3s tls         # 마스터 노드에 TLS SAN 설정 추가
```

### 5. 노드 및 클러스터 삭제
```bash
mpk3s delworker   # 특정 워커 노드 삭제
mpk3s delcluster  # 클러스터 전체 및 관련 설정 파일 완벽 삭제
```

## 🍺 Installation via Homebrew (Upcoming)

```bash
brew tap cnbsoft-com/tap
brew install mpk3s
```

## 📂 Project Structure

```text
k3s-helper/
├── bin/          # mpk3s 메인 실행 파일
├── libs/         # 핵심 기능을 담당하는 모듈화된 스크립트
├── dev-logs/     # 일자별 개발 기록 및 결정 사항
└── mpk3s.rb      # Homebrew 배포용 Formula
```

## 📄 License
This project is licensed under the **MIT License**.

---
*Developed with ❤️ by IK-YONG CHOI (AA Master)*
