# ShipIt!

ポートフォリオ共有・探索サービス。

主に初学者・転職活動中のエンジニアが、他者のポートフォリオを条件付きで検索・共有できるプラットフォームです。

---

## 技術スタック

| 領域 | 技術 |
|---|---|
| フロントエンド | Next.js 15 / Tailwind CSS / TypeScript |
| バックエンド | Ruby 3.3.6 / Rails 8.1 (API モード) |
| データベース | PostgreSQL 17 |
| 認証 | Devise + devise-jwt (JTI Matcher) |
| ストレージ（ローカル） | MinIO (S3 互換) |
| テスト（BE） | RSpec |
| テスト（FE） | Vitest + Testing Library |
| 環境構築 | Docker / Docker Compose |
| デプロイ（FE） | Vercel |
| デプロイ（BE） | Render |
| CI/CD | GitHub Actions |

---

## ディレクトリ構成

```
ShipIt/
├── backend/          # Rails 8.1 API
├── frontend/         # Next.js 15
├── docker-compose.yml
├── docs/
│   └── 設計書/
│       ├── 要件定義書.md
│       ├── DB設計書.md
│       └── ER図.md
└── README.md
```

---

## ローカル環境構築

### 前提条件

- Docker Desktop（または Docker Engine + Docker Compose v2）

### 手順

**1. リポジトリをクローン**

```bash
git clone <repository-url>
cd ShipIt
```

**2. 環境変数ファイルを作成**

```bash
cp backend/.env.example backend/.env
```

> 開発環境ではダミー値が `.env.example` に入っているため、そのままコピーで動作します。

**3. フロントエンドの環境変数を作成**

```bash
cp frontend/.env.local.example frontend/.env.local
```

**4. Docker イメージをビルド**

```bash
docker compose build
```

**5. コンテナを起動**

```bash
docker compose up
```

初回起動時は自動で以下が実行されます。

- `bundle install`
- `rails db:prepare`（DB 作成 + マイグレーション + seed データ投入）

**6. フロントエンドを起動（別ターミナル）**

```bash
cd frontend
npm install
npm run dev
```

### アクセス先

| サービス | URL |
|---|---|
| フロントエンド | http://localhost:3000 |
| Rails API | http://localhost:3001 |
| MinIO コンソール | http://localhost:9001 |

> MinIO の初期ログイン: `minioadmin` / `minioadmin`

---

## API エンドポイント（認証）

| メソッド | パス | 説明 |
|---|---|---|
| POST | `/api/v1/auth/sign_up` | 新規登録 |
| POST | `/api/v1/auth/sign_in` | ログイン（JWT 発行） |
| DELETE | `/api/v1/auth/sign_out` | ログアウト（JWT 無効化） |

JWT は `Authorization: Bearer <token>` ヘッダーで送信します。

---

## データベース

### マイグレーション

```bash
# コンテナ内で実行
docker compose exec api bundle exec rails db:migrate

# マイグレーションをロールバック
docker compose exec api bundle exec rails db:rollback
```

### シードデータの再投入

```bash
docker compose exec api bundle exec rails db:seed
```

### テーブル一覧

**コアテーブル**

| テーブル | 説明 |
|---|---|
| `users` | ユーザー（Devise） |
| `portfolios` | ポートフォリオ投稿 |
| `follows` | フォロー関係 |
| `portfolio_reactions` | いいね |

**マスタテーブル（選択肢）**

`feature_options` / `frontend_options` / `backend_options` / `db_options` / `test_options` / `cicd_options` / `infra_options` / `deploy_front_options` / `deploy_api_options` / `deploy_db_options` / `target_categories` / `interview_feedback_options` / `experience_level_options`

**中間テーブル**

`portfolio_features` / `portfolio_frontends` / `portfolio_backends` / `portfolio_databases` / `portfolio_tests` / `portfolio_cicds` / `portfolio_infras` / `portfolio_deploy_fronts` / `portfolio_deploy_apis` / `portfolio_deploy_dbs` / `portfolio_interview_feedbacks`

---

## テスト

**バックエンド（RSpec）**

```bash
docker compose exec api bundle exec rspec
```

**フロントエンド（Vitest）**

```bash
cd frontend
npm test              # ウォッチモード
npm run test:coverage # カバレッジ付き
```

---

## 開発時のよく使うコマンド

```bash
# コンテナに入る
docker compose exec api bash

# Rails コンソール
docker compose exec api bundle exec rails c

# ログを見る
docker compose logs -f api

# コンテナを止める
docker compose down

# イメージも含めて全削除（キャッシュ問題が起きたとき）
docker compose down --rmi local -v
docker compose build --no-cache
```

---

## 環境変数一覧

### `backend/.env`

| 変数名 | 説明 | デフォルト値 |
|---|---|---|
| `DATABASE_HOST` | PostgreSQL ホスト | `db` |
| `DATABASE_USER` | PostgreSQL ユーザー | `postgres` |
| `DATABASE_PASSWORD` | PostgreSQL パスワード | `postgres` |
| `DATABASE_NAME` | DB 名 | `shipit_development` |
| `AWS_ACCESS_KEY_ID` | MinIO アクセスキー | `minioadmin` |
| `AWS_SECRET_ACCESS_KEY` | MinIO シークレット | `minioadmin` |
| `AWS_ENDPOINT` | MinIO エンドポイント | `http://minio:9000` |
| `AWS_BUCKET` | バケット名 | `shipit-dev` |
| `FRONTEND_URL` | CORS 許可オリジン | `http://localhost:3000` |
| `DEVISE_JWT_SECRET_KEY` | JWT 署名キー | （開発用ダミー値） |

### `frontend/.env.local`

| 変数名 | 説明 | デフォルト値 |
|---|---|---|
| `NEXT_PUBLIC_API_URL` | Rails API のベース URL | `http://localhost:3001/api/v1` |

---

## トラブルシューティング

**`docker compose up` 時に `docker-entrypoint` が見つからないエラーが出る**

古いキャッシュイメージが残っています。以下で解消できます。

```bash
docker compose down --rmi local -v
docker compose build --no-cache
docker compose up
```

**DB 接続エラーが出る**

DB コンテナの起動が完了する前に API が起動しようとする場合があります。
`docker compose up` を再実行するか、しばらく待ってから起動してください。
