class CreateMasterOptionTables < ActiveRecord::Migration[8.1]
  def change
    [
      :feature_options,
      :frontend_options,
      :backend_options,
      :db_options,
      :test_options,
      :cicd_options,
      :infra_options,
      :deploy_front_options,
      :deploy_api_options,
      :deploy_db_options,
      :target_categories,
      :interview_feedback_options,
      :experience_level_options
    ].each do |table_name|
      create_table table_name do |t|
        t.string :key,        limit: 50,  null: false
        t.string :label,      limit: 100, null: false
        t.integer :sort_order,            null: false
        t.boolean :is_active,             null: false, default: true
        t.timestamps null: false
      end

      add_index table_name, :key, unique: true
    end
  end
end
