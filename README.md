# ☁️ OpenStack on OCI: IaC-driven Hybrid Cloud Architecture

> **Terraform**으로 OCI 고사양 인프라를 자동화하고, **Kolla-Ansible** 기반으로 **OpenStack 프라이빗 클라우드**를 구축하는 하이브리드 네트워크 프로젝트입니다.

---

## 🎯 프로젝트 목표 (Project Goals)

### 1. IaC 기반 인프라 자동화
* **웹 GUI 콘솔 배제**
  * 인프라 구성 전 과정을 코드로 관리하여 휴먼 에러를 최소화
* **OCI 핵심 자원 프로비저닝**
  * VCN, Subnet, Internet Gateway, Route Table을 일괄 자동 구성
* **고성능 컴퓨팅 자원 확보**
  * OpenStack 구동을 위한 고사양 인스턴스(32 OCPU, 128GB RAM, 200GB 디스크)를 배포

### 2. OpenStack 프라이빗 클라우드 오케스트레이션
* **엔터프라이즈급 아키텍처 이해**
  * Nova, Neutron, Glance, Horizon 등 프라이빗 클라우드 핵심 컴포넌트를 학습
* **컨테이너 기반 배포 (Kolla-Ansible)**
  * OpenStack 서비스들을 Docker 컨테이너 기반의 All-in-One 구조로 안전하게 배포

### 3. 안전한 하이브리드 네트워킹 (Hybrid Networking)
* **네트워크 터널링 구현**
  * 로컬 환경(Mac UTM)의 가상 방화벽(pfSense)과 OCI 환경을 연동
* **WireGuard Site-to-Site VPN**
  * 암호화된 가상 터널을 통해 외부 노출 없이 안전한 사설 통신망을 수립
* **보안 접속 환경 제어**
  * 로컬 내부망에서 OCI 내부망에 숨겨진 OpenStack 대시보드 및 API에 접근

### 4. End-to-End 자원 할당 검증
* **프로비저닝 파이프라인 완성**
  * 구축된 OpenStack API를 대상으로 다시 한번 Terraform을 연동
* **클라우드 위 클라우드 검증**
  * 프라이빗 클라우드 내부에서 가상 머신과 네트워크가 정상 작동하는지 테스트

---

## 🛠 기술 스택 (Tech Stacks)

### Cloud & Infrastructure
* **Cloud Provider:** Oracle Cloud Infrastructure (OCI)
* **Host OS:** Ubuntu 22.04 LTS (32 OCPU, 128GB RAM, 200GB Boot Volume)
* **Local Lab:** Mac UTM

### DevOps & Automation
* **IaC:** HashiCorp Terraform
* **Automation:** Ansible, Kolla-Ansible
* **Container Engine:** Podman

### Private Cloud & Networking
* **Cloud Engine:** OpenStack
* **Firewall / Routing:** pfSense
* **VPN:** WireGuard (Site-to-Site)

---

## 📚 문서 (Documentation)

### 📖 가이드 및 개념 정리
* [1. Terraform 초기 설정 및 OCI 인프라 배포](docs/1.%20terratorm%20%EC%84%A4%EC%A0%95.md)
* [2. Kolla-Ansible 및 OpenStack 핵심 개념 정리](docs/2.%20kolla%20-%20ensible%3F.md)
* [3. OpenStack 기초 개념 및 아키텍처 이해](docs/3.%20openstack%20%EA%B8%B0%EC%B4%88%20%EA%B0%9C%EB%85%90.md)

### 🛠 트러블슈팅
* [Terraform 초기 설정 오류 해결기](problem_solve/terraform%20%EC%B4%88%EA%B8%B0%20%EC%84%A4%EC%A0%95%20%EC%98%A4%EB%A5%98.md)