# マスタデータ投入
# 冪等性を保つため find_or_create_by! を使用

puts "=== マスタデータ投入開始 ==="

# 経験年数
ExperienceLevelOption.find_or_create_by!(key: "no_experience")   { |r| r.label = "未経験";           r.sort_order = 1 }
ExperienceLevelOption.find_or_create_by!(key: "under_1_year")    { |r| r.label = "実務経験1年未満";  r.sort_order = 2 }
ExperienceLevelOption.find_or_create_by!(key: "1_to_3_years")    { |r| r.label = "実務経験1〜3年";   r.sort_order = 3 }
ExperienceLevelOption.find_or_create_by!(key: "over_3_years")    { |r| r.label = "実務経験3年以上";  r.sort_order = 4 }

# ターゲットカテゴリ
TargetCategory.find_or_create_by!(key: "job_hunting")    { |r| r.label = "転職活動";           r.sort_order = 1 }
TargetCategory.find_or_create_by!(key: "skill_up")       { |r| r.label = "スキルアップ";       r.sort_order = 2 }
TargetCategory.find_or_create_by!(key: "personal_dev")   { |r| r.label = "個人開発・趣味";     r.sort_order = 3 }
TargetCategory.find_or_create_by!(key: "study")          { |r| r.label = "学習目的";           r.sort_order = 4 }

# 機能
[
  { key: "auth",          label: "認証・ログイン" },
  { key: "crud",          label: "CRUD" },
  { key: "search",        label: "検索・フィルタ" },
  { key: "file_upload",   label: "ファイルアップロード" },
  { key: "payment",       label: "決済" },
  { key: "realtime",      label: "リアルタイム通信" },
  { key: "notification",  label: "通知" },
  { key: "map",           label: "地図・位置情報" },
  { key: "api",           label: "外部API連携" },
  { key: "admin",         label: "管理画面" }
].each_with_index do |data, i|
  FeatureOption.find_or_create_by!(key: data[:key]) { |r| r.label = data[:label]; r.sort_order = i + 1 }
end

# フロントエンド
[
  { key: "next_js",     label: "Next.js" },
  { key: "react",       label: "React" },
  { key: "nuxt_js",     label: "Nuxt.js" },
  { key: "vue_js",      label: "Vue.js" },
  { key: "angular",     label: "Angular" },
  { key: "svelte",      label: "Svelte / SvelteKit" },
  { key: "typescript",  label: "TypeScript（素）" },
  { key: "vanilla_js",  label: "バニラJS" },
  { key: "other_fe",    label: "その他" }
].each_with_index do |data, i|
  FrontendOption.find_or_create_by!(key: data[:key]) { |r| r.label = data[:label]; r.sort_order = i + 1 }
end

# バックエンド
[
  { key: "rails",      label: "Ruby on Rails" },
  { key: "express",    label: "Node.js / Express" },
  { key: "nest_js",    label: "NestJS" },
  { key: "django",     label: "Django" },
  { key: "fast_api",   label: "FastAPI" },
  { key: "laravel",    label: "Laravel" },
  { key: "spring",     label: "Spring Boot" },
  { key: "go",         label: "Go（Gin / Echo 等）" },
  { key: "other_be",   label: "その他" }
].each_with_index do |data, i|
  BackendOption.find_or_create_by!(key: data[:key]) { |r| r.label = data[:label]; r.sort_order = i + 1 }
end

# データベース
[
  { key: "postgresql",  label: "PostgreSQL" },
  { key: "mysql",       label: "MySQL / MariaDB" },
  { key: "sqlite",      label: "SQLite" },
  { key: "mongodb",     label: "MongoDB" },
  { key: "redis",       label: "Redis" },
  { key: "firebase",    label: "Firebase Firestore" },
  { key: "supabase",    label: "Supabase" },
  { key: "other_db",    label: "その他" }
].each_with_index do |data, i|
  DbOption.find_or_create_by!(key: data[:key]) { |r| r.label = data[:label]; r.sort_order = i + 1 }
end

# テスト
[
  { key: "rspec",      label: "RSpec" },
  { key: "minitest",   label: "Minitest" },
  { key: "jest",       label: "Jest" },
  { key: "vitest",     label: "Vitest" },
  { key: "cypress",    label: "Cypress" },
  { key: "playwright", label: "Playwright" },
  { key: "other_test", label: "その他" }
].each_with_index do |data, i|
  TestOption.find_or_create_by!(key: data[:key]) { |r| r.label = data[:label]; r.sort_order = i + 1 }
end

# CI/CD
[
  { key: "github_actions", label: "GitHub Actions" },
  { key: "circle_ci",      label: "CircleCI" },
  { key: "other_cicd",     label: "その他" }
].each_with_index do |data, i|
  CicdOption.find_or_create_by!(key: data[:key]) { |r| r.label = data[:label]; r.sort_order = i + 1 }
end

# インフラ
[
  { key: "docker",       label: "Docker" },
  { key: "kubernetes",   label: "Kubernetes" },
  { key: "aws",          label: "AWS" },
  { key: "gcp",          label: "GCP" },
  { key: "azure",        label: "Azure" },
  { key: "other_infra",  label: "その他" }
].each_with_index do |data, i|
  InfraOption.find_or_create_by!(key: data[:key]) { |r| r.label = data[:label]; r.sort_order = i + 1 }
end

# デプロイ（フロントエンド）
[
  { key: "vercel",          label: "Vercel" },
  { key: "netlify",         label: "Netlify" },
  { key: "cloudflare",      label: "Cloudflare Pages" },
  { key: "aws_s3_cf",       label: "AWS S3 + CloudFront" },
  { key: "other_deploy_fe", label: "その他" }
].each_with_index do |data, i|
  DeployFrontOption.find_or_create_by!(key: data[:key]) { |r| r.label = data[:label]; r.sort_order = i + 1 }
end

# デプロイ（APIサーバー）
[
  { key: "render",           label: "Render" },
  { key: "fly_io",           label: "Fly.io" },
  { key: "railway",          label: "Railway" },
  { key: "heroku",           label: "Heroku" },
  { key: "aws_ec2",          label: "AWS EC2" },
  { key: "aws_ecs",          label: "AWS ECS" },
  { key: "gcp_run",          label: "Google Cloud Run" },
  { key: "other_deploy_api", label: "その他" }
].each_with_index do |data, i|
  DeployApiOption.find_or_create_by!(key: data[:key]) { |r| r.label = data[:label]; r.sort_order = i + 1 }
end

# デプロイ（DB）
[
  { key: "render_db",       label: "Render (PostgreSQL)" },
  { key: "supabase_db",     label: "Supabase" },
  { key: "aws_rds",         label: "AWS RDS" },
  { key: "neon",            label: "Neon" },
  { key: "other_deploy_db", label: "その他" }
].each_with_index do |data, i|
  DeployDbOption.find_or_create_by!(key: data[:key]) { |r| r.label = data[:label]; r.sort_order = i + 1 }
end

# 面接フィードバック
[
  { key: "tech_stack",   label: "技術スタックについて質問された" },
  { key: "design",       label: "設計について質問された" },
  { key: "code_quality", label: "コードの品質・可読性を評価された" },
  { key: "test",         label: "テストコードについて質問された" },
  { key: "improvement",  label: "改善点を提案された" },
  { key: "positive",     label: "好評だった" },
  { key: "other_if",     label: "その他" }
].each_with_index do |data, i|
  InterviewFeedbackOption.find_or_create_by!(key: data[:key]) { |r| r.label = data[:label]; r.sort_order = i + 1 }
end

puts "=== マスタデータ投入完了 ==="
