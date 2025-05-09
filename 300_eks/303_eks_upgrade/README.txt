# Terraform EKS 클러스터 구성

## 개요
이 Terraform 구성은 Amazon EKS(Elastic Kubernetes Service) 클러스터를 설정하며, 
OIDC 프로바이더, EKS 애드온, EKS 노드 그룹과 같은 필수 구성 요소를 포함합니다. 
또한, S3 백엔드를 사용하여 원격 상태 관리를 수행합니다.

## 사전 요구 사항
- Terraform이 설치됨
- AWS CLI가 필요한 권한으로 설정됨
- 원격 상태 관리를 위한 S3 버킷이 존재함
- 필요한 IAM 역할 및 정책이 사전에 구성됨


## 생성되는 리소스

### 1. **원격 상태 데이터 소스**
- S3에 저장된 기존 Terraform 원격 상태에서 네트워크 설정(서브넷 ID 등)을 가져옵니다.

### 2. **EKS 클러스터**
- EKS 클러스터를 생성하며, 프라이빗 엔드포인트만 활성화합니다.
- 클러스터 운영을 위한 사전 정의된 IAM 역할을 사용합니다.
- 보안 그룹 및 VPC 서브넷과 연결됩니다.

### 3. **OIDC 프로바이더**
- 인증을 위한 OpenID Connect (OIDC) 프로바이더를 구성합니다.
- EKS 클러스터의 OIDC ID 발급자 및 TLS 인증서를 사용합니다.

### 4. **EKS 애드온**
- 필수 EKS 애드온을 설치합니다:
  - `vpc-cni`: 네트워킹을 위한 CNI 플러그인
  - `coredns`: 클러스터 내 DNS 해석을 위한 서비스
  - `kube-proxy`: Kubernetes 네트워크 요청을 프록시 처리

### 5. **EKS 노드 그룹**
- 자동 확장되는 노드 그룹을 프로비저닝합니다.
- 스케일링 정책을 정의합니다 (최소: 1, 최대: 2, 기본: 1).
- 워커 노드를 EKS 클러스터에 연결합니다.

## 변수
| 변수명               | 설명                           |
|----------------------|------------------------------  |
| `eks_cluster_name`   | EKS 클러스터의 이름             |
| `eks_cluster_role_arn` | EKS 클러스터용 IAM 역할 ARN   |
| `eks_version`        | 클러스터의 Kubernetes 버전      |
| `eks_sg_id`         | EKS 보안 그룹 ID                 |
| `vpc_cni_version`   | `vpc-cni` 애드온 버전            |
| `coredns_version`   | `coredns` 애드온 버전       |
| `kube_proxy_version` | `kube-proxy` 애드온 버전   |
| `eks_ng_name`       | EKS 노드 그룹의 이름         |
| `eks_ng_type`       | 워커 노드의 인스턴스 타입   |
| `eks_ng_role_arn`   | 노드 그룹용 IAM 역할 ARN   |

## 사용 방법

1. **Terraform 초기화**
   ```sh
   terraform init
   ```

2. **배포 계획 확인**
   ```sh
   terraform plan
   ```

3. **구성 적용**
   ```sh
   terraform apply
   ```

4. **리소스 삭제 (필요한 경우)**
   ```sh
   terraform destroy
   ```

## 참고 사항
- `terraform_remote_state`의 `profile` 필드는 AWS CLI 설정에 따라 조정해야 합니다.
- Terraform을 실행하기 전에 필요한 IAM 역할과 정책이 미리 설정되어 있어야 합니다.
- 이 구성은 기존 네트워크 설정(Terraform으로 관리되는)을 기반으로 작동합니다.

## 작성자
- **관리팀:** 퍼블릭클라우드팀
- **문의:** alin@shinsegae.com

