#!/bin/bash

# .oci/config 파일의 절대 경로 설정
OCI_DIR="$(cd "$(dirname "$BASH_SOURCE")/../.oci" && pwd)"
CONFIG_FILE="$OCI_DIR/config"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: $CONFIG_FILE 파일을 찾을 수 없습니다."
  return 1 2>/dev/null || exit 1
fi

# config 파일에서 변수 추출 및 환경 변수 설정
export TF_VAR_user_ocid=$(grep '^user=' "$CONFIG_FILE" | cut -d'=' -f2)
export TF_VAR_fingerprint=$(grep '^fingerprint=' "$CONFIG_FILE" | cut -d'=' -f2)
export TF_VAR_tenancy_ocid=$(grep '^tenancy=' "$CONFIG_FILE" | cut -d'=' -f2)
export TF_VAR_region=$(grep '^region=' "$CONFIG_FILE" | cut -d'=' -f2)

KEY_FILE_NAME=$(grep '^key_file=' "$CONFIG_FILE" | cut -d'=' -f2)

# key_file 경로가 상대 경로인 경우 OCI_DIR를 기준으로 절대 경로로 변경
if [[ "$KEY_FILE_NAME" = /* ]]; then
  export TF_VAR_private_key_path="$KEY_FILE_NAME"
else
  export TF_VAR_private_key_path="$OCI_DIR/$KEY_FILE_NAME"
fi

echo "✅ OCI 인증 환경 변수가 설정되었습니다."
echo "TF_VAR_tenancy_ocid: $TF_VAR_tenancy_ocid"
echo "TF_VAR_user_ocid: $TF_VAR_user_ocid"
echo "TF_VAR_fingerprint: $TF_VAR_fingerprint"
echo "TF_VAR_region: $TF_VAR_region"
echo "TF_VAR_private_key_path: $TF_VAR_private_key_path"
