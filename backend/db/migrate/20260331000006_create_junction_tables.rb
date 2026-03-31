class CreateJunctionTables < ActiveRecord::Migration[8.1]
  JUNCTION_TABLES = {
    portfolio_features:            :feature_option_id,
    portfolio_frontends:           :frontend_option_id,
    portfolio_backends:            :backend_option_id,
    portfolio_databases:           :db_option_id,
    portfolio_tests:               :test_option_id,
    portfolio_cicds:               :cicd_option_id,
    portfolio_infras:              :infra_option_id,
    portfolio_deploy_fronts:       :deploy_front_option_id,
    portfolio_deploy_apis:         :deploy_api_option_id,
    portfolio_deploy_dbs:          :deploy_db_option_id,
    portfolio_interview_feedbacks: :interview_feedback_option_id
  }.freeze

  OPTION_TABLE_MAP = {
    feature_option_id:            :feature_options,
    frontend_option_id:           :frontend_options,
    backend_option_id:            :backend_options,
    db_option_id:                 :db_options,
    test_option_id:               :test_options,
    cicd_option_id:               :cicd_options,
    infra_option_id:              :infra_options,
    deploy_front_option_id:       :deploy_front_options,
    deploy_api_option_id:         :deploy_api_options,
    deploy_db_option_id:          :deploy_db_options,
    interview_feedback_option_id: :interview_feedback_options
  }.freeze

  def change
    JUNCTION_TABLES.each do |table_name, option_col|
      create_table table_name do |t|
        t.bigint :portfolio_id, null: false
        t.bigint option_col,    null: false
        t.datetime :created_at, null: false
      end

      add_index table_name, [ :portfolio_id, option_col ], unique: true
      add_index table_name, option_col
      add_foreign_key table_name, :portfolios
      add_foreign_key table_name, OPTION_TABLE_MAP[option_col], column: option_col
    end
  end
end
