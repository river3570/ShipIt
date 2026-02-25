# DB設計書

## 1. 概要

### 1.1 技術前提

- DB：PostgreSQL
- Backend：Rails 8 API
- 画像：DBに格納せず、S3ストレージに保存しURLを保持

---

## 2. 設計方針

### 2.1 画像/ファイル

画像（サムネ、構成図）はURLのみDBに保持する。

### 2.3 命名規則

- テーブル：snake_case / 複数形
- PK：`id`
- FK：`xxx_id`
- 中間テーブル：`portfolio_xxx`（`portfolio_id` + `xxx_option_id`）

---

## 3. ER（論理）

- users 1 — N portfolios
- users N — N users（follows）
- users N — N portfolios（portfolio_reactions）
- portfolios N — N 各種マスタ（features / stacks / deploy / interview_feedbackなど）

---

## 4. テーブル一覧

### 4.1 マスタテーブル

- feature_options
- frontend_options
- backend_options
- db_options
- test_options
- cicd_options
- infra_options
- deploy_front_options
- deploy_api_options
- deploy_db_options
- target_categories
- interview_feedback_options
- experience_level_options

### 4.2 中間テーブル

- portfolio_features
- portfolio_frontends
- portfolio_backends
- portfolio_databases
- portfolio_tests
- portfolio_cicds
- portfolio_infras
- portfolio_deploy_fronts
- portfolio_deploy_apis
- portfolio_deploy_dbs
- portfolio_interview_feedbacks

---

## 5. テーブル定義

## 5.1 users（Devise）

| 論理名      | 物理名                     | 型           | NULL | 制約/備考        |
| ----------- | -------------------------- | ------------ | ---- | ---------------- |
| ユーザーID  | id                         | bigserial    | NO   | PK               |
| メール      | email                      | varchar(255) | NO   | UNIQUE（Devise） |
| パスワード  | encrypted_password         | varchar(255) | NO   | Devise           |
| 表示名      | username                   | varchar(30)  | YES  |                  |
| 自己紹介    | bio                        | text         | YES  |                  |
| アイコンURL | avatar_url                 | text         | YES  |                  |
| 経験年数    | experience_level_option_id | int          | YES  |                  |
| 作成日時    | created_at                 | timestamptz  | NO   |                  |
| 更新日時    | updated_at                 | timestamptz  | NO   |                  |

---

## 5.2 portfolios

| 論理名                     | 物理名                  | 型           | NULL | 制約/備考                          |
| -------------------------- | ----------------------- | ------------ | ---- | ---------------------------------- |
| ポートフォリオID           | id                      | bigserial    | NO   | PK                                 |
| 投稿者                     | user_id                 | bigint       | NO   | FK → users(id)                     |
| アプリ名                   | name                    | varchar(120) | NO   |                                    |
| 概要                       | summary                 | varchar(280) | NO   | 一覧用                             |
| サムネURL                  | thumbnail_url           | text         | YES  | 任意                               |
| 作成期間入力方式           | build_period_type       | smallint     | NO   | 0:weeks / 1:months / 2:range       |
| 作成期間値                 | build_period_value      | integer      | YES  | weeks/月数                         |
| 開始日                     | build_started_on        | date         | YES  | range用                            |
| 終了日                     | build_ended_on          | date         | YES  | range用                            |
| GitHub URL                 | github_url              | text         | YES  | 任意                               |
| デプロイURL                | deploy_url              | text         | YES  | 任意                               |
| デプロイ構成図URL          | deploy_diagram_url      | text         | YES  | 任意                               |
| デプロイ補足               | deploy_notes            | text         | YES  | 任意                               |
| ターゲットカテゴリ         | target_category_id      | bigint       | YES  | FK → target_categories(id)         |
| 面接で評価された点（補足） | interview_feedback_note | text         | YES  |                                    |
| 公開状態                   | status                  | smallint     | NO   | 0:draft / 1:published              |
| その他記載事項             | other_notes             | text         | YES  | 自由記述（補足・注意点・制約など） |
| 公開日時                   | published_at            | timestamptz  | YES  |                                    |
| 作成日時                   | created_at              | timestamptz  | NO   |                                    |
| 更新日時                   | updated_at              | timestamptz  | NO   |                                    |

**Index / Constraint**

- INDEX(portfolios_user_id)
- INDEX(portfolios_status_published_at)

---

## 5.3 follows

| 論理名           | 物理名      | 型          | NULL | 制約/備考      |
| ---------------- | ----------- | ----------- | ---- | -------------- |
| ID               | id          | bigserial   | NO   | PK             |
| フォローする側   | follower_id | bigint      | NO   | FK → users(id) |
| フォローされる側 | followee_id | bigint      | NO   | FK → users(id) |
| 作成日時         | created_at  | timestamptz | NO   |                |

**Index / Constraint**

- UNIQUE(follower_id, followee_id)
- CHECK(follower_id <> followee_id)

---

## 5.4 portfolio_reactions

| 論理名         | 物理名       | 型          | NULL | 制約/備考           |
| -------------- | ------------ | ----------- | ---- | ------------------- |
| ID             | id           | bigserial   | NO   | PK                  |
| ユーザー       | user_id      | bigint      | NO   | FK → users(id)      |
| ポートフォリオ | portfolio_id | bigint      | NO   | FK → portfolios(id) |
| 作成日時       | created_at   | timestamptz | NO   |                     |

**Index / Constraint**

- UNIQUE(user_id, portfolio_id)

---

## 6. マスタテーブル（共通）

| カラム     | 型           | NULL | 備考         |
| ---------- | ------------ | ---- | ------------ |
| id         | bigserial    | NO   | PK           |
| key        | varchar(50)  | NO   | UNIQUE       |
| label      | varchar(100) | NO   | 表示名       |
| sort_order | integer      | NO   | 表示順       |
| is_active  | boolean      | NO   | default true |
| created_at | timestamptz  | NO   |              |
| updated_at | timestamptz  | NO   |              |

---

## 7. 中間テーブル（共通）

| カラム        | 型          | NULL | 備考                 |
| ------------- | ----------- | ---- | -------------------- |
| id            | bigserial   | NO   | PK                   |
| portfolio_id  | bigint      | NO   | FK → portfolios(id)  |
| xxx_option_id | bigint      | NO   | FK → xxx_options(id) |
| created_at    | timestamptz | NO   |                      |

**Constraint**

- UNIQUE(portfolio_id, xxx_option_id)

---

## 8. 中間テーブル一覧

| テーブル名                    | option_id列                  |
| ----------------------------- | ---------------------------- |
| portfolio_features            | feature_option_id            |
| portfolio_frontends           | frontend_option_id           |
| portfolio_backends            | backend_option_id            |
| portfolio_databases           | db_option_id                 |
| portfolio_tests               | test_option_id               |
| portfolio_cicds               | cicd_option_id               |
| portfolio_infras              | infra_option_id              |
| portfolio_deploy_fronts       | deploy_front_option_id       |
| portfolio_deploy_apis         | deploy_api_option_id         |
| portfolio_deploy_dbs          | deploy_db_option_id          |
| portfolio_interview_feedbacks | interview_feedback_option_id |

---

## 9. 改訂履歴

- v1（2026-01-15）：MVP版 初版

```markdown
# DB設計書

## 1. 概要

### 1.1 技術前提

- DB：PostgreSQL
- Backend：Rails 8 API
- 画像：DBに格納せず、S3ストレージに保存しURLを保持

---

## 2. 設計方針

### 2.1 画像/ファイル

画像（サムネ、構成図）はURLのみDBに保持する。

### 2.3 命名規則

- テーブル：snake_case / 複数形
- PK：`id`
- FK：`xxx_id`
- 中間テーブル：`portfolio_xxx`（`portfolio_id` + `xxx_option_id`）

---

## 3. ER（論理）

- users 1 — N portfolios
- users N — N users（follows）
- users N — N portfolios（portfolio_reactions）
- portfolios N — N 各種マスタ（features / stacks / deploy / interview_feedbackなど）

---

## 4. テーブル一覧

### 4.1 マスタテーブル

- feature_options
- frontend_options
- backend_options
- db_options
- test_options
- cicd_options
- infra_options
- deploy_front_options
- deploy_api_options
- deploy_db_options
- target_categories
- interview_feedback_options
- experience_level_options

### 4.2 中間テーブル

- portfolio_features
- portfolio_frontends
- portfolio_backends
- portfolio_databases
- portfolio_tests
- portfolio_cicds
- portfolio_infras
- portfolio_deploy_fronts
- portfolio_deploy_apis
- portfolio_deploy_dbs
- portfolio_interview_feedbacks

---

## 5. テーブル定義

## 5.1 users（Devise）

| 論理名      | 物理名                     | 型           | NULL | 制約/備考        |
| ----------- | -------------------------- | ------------ | ---- | ---------------- |
| ユーザーID  | id                         | bigserial    | NO   | PK               |
| メール      | email                      | varchar(255) | NO   | UNIQUE（Devise） |
| パスワード  | encrypted_password         | varchar(255) | NO   | Devise           |
| 表示名      | username                   | varchar(30)  | YES  |                  |
| 自己紹介    | bio                        | text         | YES  |                  |
| 経験年数    | experience_level_option_id | int          | YES  |                  |
| アイコンURL | avatar_url                 | text         | YES  |                  |
| 作成日時    | created_at                 | timestamptz  | NO   |                  |
| 更新日時    | updated_at                 | timestamptz  | NO   |                  |

---

## 5.2 portfolios

| 論理名                     | 物理名                  | 型           | NULL | 制約/備考                          |
| -------------------------- | ----------------------- | ------------ | ---- | ---------------------------------- |
| ポートフォリオID           | id                      | bigserial    | NO   | PK                                 |
| 投稿者                     | user_id                 | bigint       | NO   | FK → users(id)                     |
| アプリ名                   | name                    | varchar(120) | NO   |                                    |
| 概要                       | summary                 | varchar(280) | NO   | 一覧用                             |
| サムネURL                  | thumbnail_url           | text         | YES  | 任意                               |
| 作成期間入力方式           | build_period_type       | smallint     | NO   | 0:weeks / 1:months / 2:range       |
| 作成期間値                 | build_period_value      | integer      | YES  | weeks/月数                         |
| 開始日                     | build_started_on        | date         | YES  | range用                            |
| 終了日                     | build_ended_on          | date         | YES  | range用                            |
| GitHub URL                 | github_url              | text         | YES  | 任意                               |
| デプロイURL                | deploy_url              | text         | YES  | 任意                               |
| デプロイ構成図URL          | deploy_diagram_url      | text         | YES  | 任意                               |
| デプロイ補足               | deploy_notes            | text         | YES  | 任意                               |
| ターゲットカテゴリ         | target_category_id      | bigint       | YES  | FK → target_categories(id)         |
| 面接で評価された点（補足） | interview_feedback_note | text         | YES  |                                    |
| 公開状態                   | status                  | smallint     | NO   | 0:draft / 1:published              |
| その他記載事項             | other_notes             | text         | YES  | 自由記述（補足・注意点・制約など） |
| 公開日時                   | published_at            | timestamptz  | YES  |                                    |
| 作成日時                   | created_at              | timestamptz  | NO   |                                    |
| 更新日時                   | updated_at              | timestamptz  | NO   |                                    |

**Index / Constraint**

- INDEX(portfolios_user_id)
- INDEX(portfolios_status_published_at)

---

## 5.3 follows

| 論理名           | 物理名      | 型          | NULL | 制約/備考      |
| ---------------- | ----------- | ----------- | ---- | -------------- |
| ID               | id          | bigserial   | NO   | PK             |
| フォローする側   | follower_id | bigint      | NO   | FK → users(id) |
| フォローされる側 | followee_id | bigint      | NO   | FK → users(id) |
| 作成日時         | created_at  | timestamptz | NO   |                |

**Index / Constraint**

- UNIQUE(follower_id, followee_id)
- CHECK(follower_id <> followee_id)

---

## 5.4 portfolio_reactions

| 論理名         | 物理名       | 型          | NULL | 制約/備考           |
| -------------- | ------------ | ----------- | ---- | ------------------- |
| ID             | id           | bigserial   | NO   | PK                  |
| ユーザー       | user_id      | bigint      | NO   | FK → users(id)      |
| ポートフォリオ | portfolio_id | bigint      | NO   | FK → portfolios(id) |
| 作成日時       | created_at   | timestamptz | NO   |                     |

**Index / Constraint**

- UNIQUE(user_id, portfolio_id)

---

## 6. マスタテーブル（共通）

| カラム     | 型           | NULL | 備考         |
| ---------- | ------------ | ---- | ------------ |
| id         | bigserial    | NO   | PK           |
| key        | varchar(50)  | NO   | UNIQUE       |
| label      | varchar(100) | NO   | 表示名       |
| sort_order | integer      | NO   | 表示順       |
| is_active  | boolean      | NO   | default true |
| created_at | timestamptz  | NO   |              |
| updated_at | timestamptz  | NO   |              |

---

## 7. 中間テーブル（共通）

| カラム        | 型          | NULL | 備考                 |
| ------------- | ----------- | ---- | -------------------- |
| id            | bigserial   | NO   | PK                   |
| portfolio_id  | bigint      | NO   | FK → portfolios(id)  |
| xxx_option_id | bigint      | NO   | FK → xxx_options(id) |
| created_at    | timestamptz | NO   |                      |

**Constraint**

- UNIQUE(portfolio_id, xxx_option_id)

---

## 8. 中間テーブル一覧

| テーブル名                    | option_id列                  |
| ----------------------------- | ---------------------------- |
| portfolio_features            | feature_option_id            |
| portfolio_frontends           | frontend_option_id           |
| portfolio_backends            | backend_option_id            |
| portfolio_databases           | db_option_id                 |
| portfolio_tests               | test_option_id               |
| portfolio_cicds               | cicd_option_id               |
| portfolio_infras              | infra_option_id              |
| portfolio_deploy_fronts       | deploy_front_option_id       |
| portfolio_deploy_apis         | deploy_api_option_id         |
| portfolio_deploy_dbs          | deploy_db_option_id          |
| portfolio_interview_feedbacks | interview_feedback_option_id |

---

## 9. 改訂履歴

- v1（2026-01-15）：MVP版 初版
```
