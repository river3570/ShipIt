# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_31_000006) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "backend_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_backend_options_on_key", unique: true
  end

  create_table "cicd_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_cicd_options_on_key", unique: true
  end

  create_table "db_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_db_options_on_key", unique: true
  end

  create_table "deploy_api_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_deploy_api_options_on_key", unique: true
  end

  create_table "deploy_db_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_deploy_db_options_on_key", unique: true
  end

  create_table "deploy_front_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_deploy_front_options_on_key", unique: true
  end

  create_table "experience_level_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_experience_level_options_on_key", unique: true
  end

  create_table "feature_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_feature_options_on_key", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "followee_id", null: false
    t.bigint "follower_id", null: false
    t.index ["followee_id"], name: "index_follows_on_followee_id"
    t.index ["follower_id", "followee_id"], name: "index_follows_on_follower_id_and_followee_id", unique: true
    t.check_constraint "follower_id <> followee_id", name: "chk_no_self_follow"
  end

  create_table "frontend_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_frontend_options_on_key", unique: true
  end

  create_table "infra_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_infra_options_on_key", unique: true
  end

  create_table "interview_feedback_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_interview_feedback_options_on_key", unique: true
  end

  create_table "portfolio_backends", force: :cascade do |t|
    t.bigint "backend_option_id", null: false
    t.datetime "created_at", null: false
    t.bigint "portfolio_id", null: false
    t.index ["backend_option_id"], name: "index_portfolio_backends_on_backend_option_id"
    t.index ["portfolio_id", "backend_option_id"], name: "index_portfolio_backends_on_portfolio_id_and_backend_option_id", unique: true
  end

  create_table "portfolio_cicds", force: :cascade do |t|
    t.bigint "cicd_option_id", null: false
    t.datetime "created_at", null: false
    t.bigint "portfolio_id", null: false
    t.index ["cicd_option_id"], name: "index_portfolio_cicds_on_cicd_option_id"
    t.index ["portfolio_id", "cicd_option_id"], name: "index_portfolio_cicds_on_portfolio_id_and_cicd_option_id", unique: true
  end

  create_table "portfolio_databases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "db_option_id", null: false
    t.bigint "portfolio_id", null: false
    t.index ["db_option_id"], name: "index_portfolio_databases_on_db_option_id"
    t.index ["portfolio_id", "db_option_id"], name: "index_portfolio_databases_on_portfolio_id_and_db_option_id", unique: true
  end

  create_table "portfolio_deploy_apis", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "deploy_api_option_id", null: false
    t.bigint "portfolio_id", null: false
    t.index ["deploy_api_option_id"], name: "index_portfolio_deploy_apis_on_deploy_api_option_id"
    t.index ["portfolio_id", "deploy_api_option_id"], name: "idx_on_portfolio_id_deploy_api_option_id_41915096fe", unique: true
  end

  create_table "portfolio_deploy_dbs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "deploy_db_option_id", null: false
    t.bigint "portfolio_id", null: false
    t.index ["deploy_db_option_id"], name: "index_portfolio_deploy_dbs_on_deploy_db_option_id"
    t.index ["portfolio_id", "deploy_db_option_id"], name: "idx_on_portfolio_id_deploy_db_option_id_3d1ccc8c39", unique: true
  end

  create_table "portfolio_deploy_fronts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "deploy_front_option_id", null: false
    t.bigint "portfolio_id", null: false
    t.index ["deploy_front_option_id"], name: "index_portfolio_deploy_fronts_on_deploy_front_option_id"
    t.index ["portfolio_id", "deploy_front_option_id"], name: "idx_on_portfolio_id_deploy_front_option_id_e45e4dda11", unique: true
  end

  create_table "portfolio_features", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "feature_option_id", null: false
    t.bigint "portfolio_id", null: false
    t.index ["feature_option_id"], name: "index_portfolio_features_on_feature_option_id"
    t.index ["portfolio_id", "feature_option_id"], name: "index_portfolio_features_on_portfolio_id_and_feature_option_id", unique: true
  end

  create_table "portfolio_frontends", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "frontend_option_id", null: false
    t.bigint "portfolio_id", null: false
    t.index ["frontend_option_id"], name: "index_portfolio_frontends_on_frontend_option_id"
    t.index ["portfolio_id", "frontend_option_id"], name: "idx_on_portfolio_id_frontend_option_id_1398511714", unique: true
  end

  create_table "portfolio_infras", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "infra_option_id", null: false
    t.bigint "portfolio_id", null: false
    t.index ["infra_option_id"], name: "index_portfolio_infras_on_infra_option_id"
    t.index ["portfolio_id", "infra_option_id"], name: "index_portfolio_infras_on_portfolio_id_and_infra_option_id", unique: true
  end

  create_table "portfolio_interview_feedbacks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "interview_feedback_option_id", null: false
    t.bigint "portfolio_id", null: false
    t.index ["interview_feedback_option_id"], name: "idx_on_interview_feedback_option_id_a9eadc6a9f"
    t.index ["portfolio_id", "interview_feedback_option_id"], name: "idx_on_portfolio_id_interview_feedback_option_id_ca00cf4035", unique: true
  end

  create_table "portfolio_reactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "portfolio_id", null: false
    t.bigint "user_id", null: false
    t.index ["portfolio_id"], name: "index_portfolio_reactions_on_portfolio_id"
    t.index ["user_id", "portfolio_id"], name: "index_portfolio_reactions_on_user_id_and_portfolio_id", unique: true
  end

  create_table "portfolio_tests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "portfolio_id", null: false
    t.bigint "test_option_id", null: false
    t.index ["portfolio_id", "test_option_id"], name: "index_portfolio_tests_on_portfolio_id_and_test_option_id", unique: true
    t.index ["test_option_id"], name: "index_portfolio_tests_on_test_option_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.date "build_ended_on"
    t.integer "build_period_type", null: false, comment: "0:weeks / 1:months / 2:range"
    t.integer "build_period_value"
    t.date "build_started_on"
    t.datetime "created_at", null: false
    t.text "deploy_diagram_url"
    t.text "deploy_notes"
    t.text "deploy_url"
    t.text "github_url"
    t.text "interview_feedback_note"
    t.string "name", limit: 120, null: false
    t.text "other_notes"
    t.datetime "published_at"
    t.integer "status", default: 0, null: false, comment: "0:draft / 1:published"
    t.string "summary", limit: 280, null: false
    t.bigint "target_category_id"
    t.text "thumbnail_url"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["status", "published_at"], name: "index_portfolios_on_status_and_published_at"
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "target_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_target_categories_on_key", unique: true
  end

  create_table "test_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "key", limit: 50, null: false
    t.string "label", limit: 100, null: false
    t.integer "sort_order", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_test_options_on_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.text "avatar_url"
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.bigint "experience_level_option_id"
    t.string "jti", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username", limit: 30
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["experience_level_option_id"], name: "index_users_on_experience_level_option_id"
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "follows", "users", column: "followee_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "portfolio_backends", "backend_options"
  add_foreign_key "portfolio_backends", "portfolios"
  add_foreign_key "portfolio_cicds", "cicd_options"
  add_foreign_key "portfolio_cicds", "portfolios"
  add_foreign_key "portfolio_databases", "db_options"
  add_foreign_key "portfolio_databases", "portfolios"
  add_foreign_key "portfolio_deploy_apis", "deploy_api_options"
  add_foreign_key "portfolio_deploy_apis", "portfolios"
  add_foreign_key "portfolio_deploy_dbs", "deploy_db_options"
  add_foreign_key "portfolio_deploy_dbs", "portfolios"
  add_foreign_key "portfolio_deploy_fronts", "deploy_front_options"
  add_foreign_key "portfolio_deploy_fronts", "portfolios"
  add_foreign_key "portfolio_features", "feature_options"
  add_foreign_key "portfolio_features", "portfolios"
  add_foreign_key "portfolio_frontends", "frontend_options"
  add_foreign_key "portfolio_frontends", "portfolios"
  add_foreign_key "portfolio_infras", "infra_options"
  add_foreign_key "portfolio_infras", "portfolios"
  add_foreign_key "portfolio_interview_feedbacks", "interview_feedback_options"
  add_foreign_key "portfolio_interview_feedbacks", "portfolios"
  add_foreign_key "portfolio_reactions", "portfolios"
  add_foreign_key "portfolio_reactions", "users"
  add_foreign_key "portfolio_tests", "portfolios"
  add_foreign_key "portfolio_tests", "test_options"
  add_foreign_key "portfolios", "target_categories"
  add_foreign_key "portfolios", "users"
end
