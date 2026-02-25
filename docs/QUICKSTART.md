# ShipIt! クイックスタートガイド

## 前提条件

以下がインストールされていることを確認してください:

- **Docker Desktop**: バックエンド・DB・MinIO用
- **Node.js 22系以上**: フロントエンド用
- **Git**: リポジトリ管理用

### Node.jsのバージョン確認

```bash
node -v  # v22.x.x であることを確認
npm -v   # 10.x.x 以上であることを確認
```

Node.jsがインストールされていない、またはバージョンが古い場合は、[公式サイト](https://nodejs.org/)からインストールしてください。

---

## セットアップ手順

### 1. リポジトリのクローン

```bash
git clone https://github.com/yourusername/shipit.git
cd shipit
```

### 2. 環境変数ファイルの作成

```bash
# ルートディレクトリ
cp .env.example .env

# バックエンド
cp backend/.env.example backend/.env

# フロントエンド
cp frontend/.env.local.example frontend/.env.local
```

### 3. バックエンド環境の起動 (Docker)

```bash
# Docker Composeでバックエンド・DB・MinIOを起動
docker-compose up -d

# ログを確認 (起動完了まで待つ)
docker-compose logs -f
```

起動完了の確認:
- `shipit_api` が `Listening on http://0.0.0.0:3001` を出力
- `shipit_db` が起動完了
- `shipit_minio` が起動完了

### 4. Railsアプリケーションの初期化

```bash
# コンテナ内でRailsアプリを生成
docker-compose exec api bash

# 以下、コンテナ内で実行
rails new . --api --database=postgresql --skip-git --force

# 必要なGemを追加
bundle add devise devise_token_auth active_model_serializers aws-sdk-s3 kaminari rack-cors dotenv-rails
bundle add --group development,test rspec-rails factory_bot_rails faker brakeman rubocop-rails-omakase
bundle add --group test shoulda-matchers database_cleaner-active_record simplecov
bundle add --group development annotate bullet

bundle install

# RSpecセットアップ
rails generate rspec:install

# データベース作成
rails db:create
rails db:migrate

# コンテナから抜ける
exit
```

### 5. フロントエンド (Next.js) のセットアップ

```bash
# frontendディレクトリに移動
cd frontend

# Next.jsアプリを生成
npx create-next-app@latest . --typescript --tailwind --app --src-dir --import-alias "@/*" --no-git --yes

# 依存関係をインストール
npm install

# 開発サーバーを起動
npm run dev
```

### 6. MinIOバケットの作成

1. ブラウザで http://localhost:9001 を開く
2. ログイン情報を入力:
   - **Username**: `minioadmin`
   - **Password**: `minioadmin`
3. 左メニューから「Buckets」を選択
4. 「Create Bucket」ボタンをクリック
5. Bucket Name: `shipit-dev` を入力して作成

### 7. SECRET_KEY_BASE の設定

```bash
# Rails secretを生成
docker-compose exec api rails secret
```

生成されたキーをコピーして、`backend/.env` の `SECRET_KEY_BASE` に設定:

```env
SECRET_KEY_BASE=生成されたキーをここに貼り付け
```

---

## アクセス確認

以下のURLにアクセスして、正常に動作しているか確認:

- **フロントエンド**: http://localhost:3000
- **バックエンドAPI**: http://localhost:3001
- **MinIO Console**: http://localhost:9001

---

## 開発開始

### バックエンド開発

```bash
# Railsコンソール
docker-compose exec api rails c

# マイグレーション作成
docker-compose exec api rails generate migration CreateUsers

# マイグレーション実行
docker-compose exec api rails db:migrate

# テスト実行
docker-compose exec api bundle exec rspec

# Rubocop実行
docker-compose exec api bundle exec rubocop
```

### フロントエンド開発

```bash
cd frontend

# 開発サーバー起動 (既に起動していれば不要)
npm run dev

# テスト実行
npm run test

# Lint実行
npm run lint

# 型チェック
npm run type-check

# 本番ビルド
npm run build
```

---

## よくある問題と解決方法

### ポート3000が既に使用されている

```bash
# 使用中のプロセスを確認
lsof -i :3000

# プロセスを終了するか、別のポートで起動
cd frontend
PORT=3001 npm run dev
```

### バックエンドに接続できない

```bash
# バックエンドコンテナの状態確認
docker-compose ps

# ログ確認
docker-compose logs api

# コンテナ再起動
docker-compose restart api
```

### データベース接続エラー

```bash
# データベースコンテナの確認
docker-compose ps db

# データベース再作成
docker-compose down -v
docker-compose up -d
```

### フロントエンドのホットリロードが効かない

```bash
cd frontend

# node_modules削除して再インストール
rm -rf node_modules .next
npm install
npm run dev
```

---

## 次のステップ

1. **DB設計の実装**: マイグレーションファイルを作成
2. **認証機能の実装**: devise_token_authのセットアップ
3. **API開発**: Railsコントローラーの実装
4. **フロントエンド開発**: Next.jsページ・コンポーネントの作成
5. **テストの作成**: RSpec・Vitestでのテスト実装

詳細は [README.md](../README.md) を参照してください。

---

**作成日**: 2026-02-24
