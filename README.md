# ShipIt! 🚀

エンジニア向けポートフォリオ共有・探索プラットフォーム

## 技術スタック

### フロントエンド
- Next.js 15 (App Router)
- TypeScript
- Tailwind CSS v4
- Vitest

### バックエンド
- Ruby 3.3.x
- Rails 8 (API Mode)
- RSpec

### インフラ
- PostgreSQL 17
- MinIO (開発環境のS3互換ストレージ)
- Docker & Docker Compose
- AWS (本番環境)
- GitHub Actions (CI/CD)

## 環境構築

### 必要な環境

- Docker Desktop
- Git

### セットアップ手順

1. **リポジトリのクローン**

```bash
git clone https://github.com/yourusername/shipit.git
cd shipit
```

2. **環境変数ファイルの作成**

```bash
cp .env.example .env
```

3. **バックエンド・DB・MinIOのDockerコンテナ起動**

```bash
docker-compose up -d
```

初回起動時は以下の処理が自動で実行されます:
- Rails依存関係のインストール
- データベースの作成
- マイグレーションの実行
- シードデータの投入

4. **フロントエンド (Next.js) のローカルセットアップ**

```bash
cd frontend

# Node.js 22系がインストールされていることを確認
node -v  # v22.x.x であること

# 依存関係のインストール
npm install

# 環境変数ファイルの作成
cp .env.local.example .env.local

# 開発サーバーの起動
npm run dev
```

5. **MinIOバケットの作成**

MinIO Web Console (http://localhost:9001) にアクセス:
- ユーザー名: `minioadmin`
- パスワード: `minioadmin`

Bucketsメニューから`shipit-dev`バケットを作成してください。

6. **アプリケーションへのアクセス**

- フロントエンド: http://localhost:3000 (ローカル)
- バックエンド API: http://localhost:3001 (Docker)
- MinIO Console: http://localhost:9001 (Docker)

## 開発コマンド

### 全体

```bash
# バックエンドコンテナ(API, DB, MinIO)を起動
docker-compose up -d

# ログを確認
docker-compose logs -f

# バックエンドコンテナを停止
docker-compose down

# ボリュームも含めて完全削除
docker-compose down -v
```

### バックエンド (Docker)

```bash
# Railsコンソール
docker-compose exec api rails c

# マイグレーション実行
docker-compose exec api rails db:migrate

# シードデータ投入
docker-compose exec api rails db:seed

# テスト実行
docker-compose exec api bundle exec rspec

# Rubocop実行
docker-compose exec api bundle exec rubocop

# Rubocop自動修正
docker-compose exec api bundle exec rubocop -A
```

### フロントエンド (ローカル)

```bash
# frontendディレクトリに移動
cd frontend

# 開発サーバー起動
npm run dev

# テスト実行
npm run test

# Lint実行
npm run lint

# Lint自動修正
npm run lint:fix

# 型チェック
npm run type-check

# 本番ビルド
npm run build
```

### データベース

```bash
# PostgreSQLに接続
docker-compose exec db psql -U postgres -d shipit_development

# データベースリセット
docker-compose exec api rails db:reset
```

## ディレクトリ構成

```
shipit/
├── frontend/          # Next.js (ローカル実行)
├── backend/           # Rails API (Docker)
├── .github/           # GitHub Actions CI/CD
├── docker-compose.yml # Docker構成 (Backend, DB, MinIO)
└── README.md
```

## 環境別設定

### Development (ローカル)
- **フロントエンド**: ローカルで実行 (http://localhost:3000)
- **バックエンド**: Docker (http://localhost:3001)
- **データベース**: Docker PostgreSQL
- **ストレージ**: Docker MinIO (http://localhost:9000)

### Staging
- データベース: AWS RDS
- ストレージ: AWS S3
- ホスティング: AWS ECS (Fargate)

### Production
- データベース: AWS RDS
- ストレージ: AWS S3
- ホスティング: AWS ECS (Fargate)
- CDN: CloudFront

## CI/CD

GitHub Actionsで以下を自動実行:

- **Lint**: ESLint, Rubocop
- **Test**: Vitest (Frontend), RSpec (Backend)
- **Build**: Docker images
- **Deploy**: AWS ECS (mainブランチへのマージ時)

## トラブルシューティング

### ポートが既に使用されている

```bash
# バックエンド・DBのポート確認
lsof -i :3001  # Rails API
lsof -i :5432  # PostgreSQL
lsof -i :9000  # MinIO API
lsof -i :9001  # MinIO Console

# フロントエンドのポート確認
lsof -i :3000  # Next.js

# プロセスを停止して再度実行
docker-compose down
docker-compose up -d

# フロントエンドは別途起動
cd frontend && npm run dev
```

### フロントエンドがバックエンドに接続できない

```bash
# バックエンドが起動しているか確認
docker-compose ps api

# バックエンドログ確認
docker-compose logs api

# CORS設定を確認
# backend/config/initializers/cors.rb を確認
```

### データベース接続エラー

```bash
# データベースコンテナの状態確認
docker-compose ps db

# データベースログ確認
docker-compose logs db

# データベースの再作成
docker-compose down -v
docker-compose up -d
```

### MinIOにアクセスできない

```bash
# MinIOコンテナの状態確認
docker-compose ps minio

# MinIOログ確認
docker-compose logs minio

# MinIO再起動
docker-compose restart minio
```

### フロントエンドの依存関係エラー

```bash
cd frontend

# node_modulesを削除して再インストール
rm -rf node_modules package-lock.json
npm install

# キャッシュクリア
rm -rf .next
npm run dev
```
