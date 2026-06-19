# 🚨 트러블 슈팅 (Troubleshooting)

이 문서는 프로젝트 진행 중 발생한 문제점과 해결 방법을 기록합니다.

## 1. Terraform 초기화 에러 (Inconsistent dependency lock file)
* **증상**: `terraform apply` 실행 시 OCI Provider 버전 정보가 없다는 에러(`Error: Inconsistent dependency lock file`) 발생
* **원인**: 프로젝트에 필요한 Terraform 플러그인(Provider)이 로컬 작업 공간에 아직 다운로드되지 않았거나, `.terraform.lock.hcl` 잠금 파일과 일치하지 않을 경우 발생
* **해결 방법**: 코드를 실행하기 전 최초 1회 또는 설정이 변경되었을 때 아래 초기화 명령어 실행
```bash
terraform init
```

## 2. SSH 공개키 파일 누락 에러 (Invalid function argument)
* **증상**: `terraform apply` 실행 중 `Invalid value for "path" parameter: no file exists at "~/.ssh/id_rsa.pub"` 에러 발생
* **원인**: OCI 가상 머신(VM) 생성 시 인스턴스에 등록할 SSH 공개키(`~/.ssh/id_rsa.pub`)가 로컬 PC에 존재하지 않아서 발생
* **해결 방법**: 로컬 터미널에서 `ssh-keygen` 명령어를 사용해 SSH 키 페어를 새로 생성

  ```bash
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
  ```
  생성이 완료된 후 다시 `terraform apply`를 실행하면 정상적으로 인프라 배포
