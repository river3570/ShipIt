# AWS インフラ構成ガイド

## 概要

ShipIt!の本番環境はAWS ECS (Fargate)を使用して構築します。

## アーキテクチャ図

```
Internet
    ↓
CloudFront (CDN)
    ↓
Application Load Balancer
    ↓
┌─────────────────────────────────┐
│ ECS Cluster (Fargate)           │
│  ├─ Frontend Service (Next.js)  │
│  └─ Backend Service (Rails API) │
└─────────────────────────────────┘
    ↓
┌─────────────────────────────────┐
│ RDS PostgreSQL (Multi-AZ)       │
└─────────────────────────────────┘
    
S3 Bucket (画像ストレージ)
```

## 必要なAWSサービス

### 1. VPC (ネットワーク)
- **VPC**: 1つ (例: 10.0.0.0/16)
- **Public Subnet**: 2つ (異なるAZ)
- **Private Subnet**: 2つ (異なるAZ)
- **Internet Gateway**: 1つ
- **NAT Gateway**: 2つ (各AZに1つ)

### 2. ECR (コンテナレジストリ)
- **リポジトリ**:
  - `shipit-frontend`
  - `shipit-backend`

### 3. ECS (コンテナオーケストレーション)
- **クラスター**: `shipit-cluster`
- **タスク定義**:
  - `shipit-frontend-task`
  - `shipit-backend-task`
- **サービス**:
  - `shipit-frontend-service`
  - `shipit-backend-service`

### 4. RDS (データベース)
- **エンジン**: PostgreSQL 17
- **インスタンスタイプ**: db.t4g.micro (開発) → db.t4g.small (本番)
- **Multi-AZ**: 有効
- **自動バックアップ**: 有効 (7日間保持)

### 5. S3 (ストレージ)
- **バケット**:
  - `shipit-production-assets` (画像)
  - `shipit-production-logs` (ログ)

### 6. CloudFront (CDN)
- **ディストリビューション**: フロントエンド配信用

### 7. Application Load Balancer
- **ターゲットグループ**:
  - `shipit-frontend-tg`
  - `shipit-backend-tg`

### 8. その他
- **Secrets Manager**: 環境変数・認証情報の管理
- **CloudWatch**: ログ・メトリクス
- **IAM**: 各サービスの権限管理

## セットアップ手順

### ステップ1: VPCの作成

```bash
# VPC作成
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# パブリックサブネット作成
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24 --availability-zone ap-northeast-1a
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.2.0/24 --availability-zone ap-northeast-1c

# プライベートサブネット作成
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.11.0/24 --availability-zone ap-northeast-1a
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.12.0/24 --availability-zone ap-northeast-1c
```

### ステップ2: ECRリポジトリの作成

```bash
# フロントエンド用リポジトリ
aws ecr create-repository --repository-name shipit-frontend

# バックエンド用リポジトリ
aws ecr create-repository --repository-name shipit-backend
```

### ステップ3: RDSの作成

```bash
aws rds create-db-instance \
  --db-instance-identifier shipit-production \
  --db-instance-class db.t4g.micro \
  --engine postgres \
  --engine-version 17 \
  --master-username postgres \
  --master-user-password <your-password> \
  --allocated-storage 20 \
  --vpc-security-group-ids <sg-id> \
  --db-subnet-group-name <subnet-group-name> \
  --multi-az \
  --backup-retention-period 7
```

### ステップ4: S3バケットの作成

```bash
# 画像用バケット
aws s3 mb s3://shipit-production-assets

# バケットポリシー設定 (パブリック読み取り許可)
aws s3api put-bucket-policy --bucket shipit-production-assets --policy file://bucket-policy.json
```

### ステップ5: ECSクラスター・タスク定義の作成

**frontend-task-definition.json**:
```json
{
  "family": "shipit-frontend-task",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "containerDefinitions": [
    {
      "name": "frontend",
      "image": "<ecr-repo-url>/shipit-frontend:latest",
      "portMappings": [
        {
          "containerPort": 3000,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "NEXT_PUBLIC_API_URL",
          "value": "https://api.shipit.example.com"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/shipit-frontend",
          "awslogs-region": "ap-northeast-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

**backend-task-definition.json**:
```json
{
  "family": "shipit-backend-task",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "containerDefinitions": [
    {
      "name": "backend",
      "image": "<ecr-repo-url>/shipit-backend:latest",
      "portMappings": [
        {
          "containerPort": 3001,
          "protocol": "tcp"
        }
      ],
      "secrets": [
        {
          "name": "DATABASE_PASSWORD",
          "valueFrom": "arn:aws:secretsmanager:ap-northeast-1:xxx:secret:shipit/db-password"
        },
        {
          "name": "SECRET_KEY_BASE",
          "valueFrom": "arn:aws:secretsmanager:ap-northeast-1:xxx:secret:shipit/rails-secret"
        }
      ],
      "environment": [
        {
          "name": "RAILS_ENV",
          "value": "production"
        },
        {
          "name": "DATABASE_HOST",
          "value": "<rds-endpoint>"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/shipit-backend",
          "awslogs-region": "ap-northeast-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

### ステップ6: ECSサービスの作成

```bash
# フロントエンドサービス
aws ecs create-service \
  --cluster shipit-cluster \
  --service-name shipit-frontend-service \
  --task-definition shipit-frontend-task \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxx,subnet-yyy],securityGroups=[sg-xxx],assignPublicIp=DISABLED}" \
  --load-balancers "targetGroupArn=arn:aws:elasticloadbalancing:...,containerName=frontend,containerPort=3000"

# バックエンドサービス
aws ecs create-service \
  --cluster shipit-cluster \
  --service-name shipit-backend-service \
  --task-definition shipit-backend-task \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxx,subnet-yyy],securityGroups=[sg-xxx],assignPublicIp=DISABLED}" \
  --load-balancers "targetGroupArn=arn:aws:elasticloadbalancing:...,containerName=backend,containerPort=3001"
```

## 環境変数管理

### Secrets Managerへの保存

```bash
# データベースパスワード
aws secretsmanager create-secret \
  --name shipit/production/db-password \
  --secret-string "your-db-password"

# Rails SECRET_KEY_BASE
aws secretsmanager create-secret \
  --name shipit/production/rails-secret \
  --secret-string "your-secret-key-base"

# Devise JWT Secret
aws secretsmanager create-secret \
  --name shipit/production/devise-jwt-secret \
  --secret-string "your-jwt-secret"

# AWS S3認証情報
aws secretsmanager create-secret \
  --name shipit/production/aws-credentials \
  --secret-string '{"access_key_id":"xxx","secret_access_key":"yyy"}'
```

## GitHub Secretsの設定

GitHub ActionsでデプロイするためのSecretsを設定:

- `AWS_ACCESS_KEY_ID`: AWSアクセスキー
- `AWS_SECRET_ACCESS_KEY`: AWSシークレットキー
- `PRIVATE_SUBNET_IDS`: プライベートサブネットID (カンマ区切り)
- `SECURITY_GROUP_ID`: セキュリティグループID

## コスト見積もり (月額)

### 開発環境
- **ECS Fargate** (0.25 vCPU, 0.5 GB × 2サービス): ~$15
- **RDS** (db.t4g.micro): ~$15
- **ALB**: ~$20
- **データ転送**: ~$5
- **合計**: ~$55/月

### 本番環境
- **ECS Fargate** (0.5 vCPU, 1 GB × 2サービス × 2タスク): ~$60
- **RDS** (db.t4g.small, Multi-AZ): ~$50
- **ALB**: ~$20
- **CloudFront**: ~$10
- **S3**: ~$5
- **データ転送**: ~$20
- **合計**: ~$165/月

## モニタリング

### CloudWatch Logsの確認

```bash
# フロントエンドログ
aws logs tail /ecs/shipit-frontend --follow

# バックエンドログ
aws logs tail /ecs/shipit-backend --follow
```

### メトリクス監視

- CPU使用率
- メモリ使用率
- リクエスト数
- レスポンスタイム
- エラー率

## スケーリング設定

### Auto Scaling設定例

```bash
aws application-autoscaling register-scalable-target \
  --service-namespace ecs \
  --scalable-dimension ecs:service:DesiredCount \
  --resource-id service/shipit-cluster/shipit-backend-service \
  --min-capacity 2 \
  --max-capacity 10

aws application-autoscaling put-scaling-policy \
  --service-namespace ecs \
  --scalable-dimension ecs:service:DesiredCount \
  --resource-id service/shipit-cluster/shipit-backend-service \
  --policy-name cpu-scaling-policy \
  --policy-type TargetTrackingScaling \
  --target-tracking-scaling-policy-configuration file://scaling-policy.json
```

## バックアップ戦略

1. **RDS自動バックアップ**: 7日間保持
2. **RDSスナップショット**: 週次手動バックアップ
3. **S3バージョニング**: 有効化
4. **CloudWatch Logs**: 30日間保持

## セキュリティ対策

1. **IAMロール**: 最小権限の原則
2. **Secrets Manager**: 認証情報の暗号化保存
3. **VPCセキュリティグループ**: 必要最小限のポート開放
4. **WAF**: CloudFront前段での防御
5. **SSL/TLS**: ALB・CloudFrontでの証明書設定

---

作成日: 2026-02-24
