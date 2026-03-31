class CreatePortfolios < ActiveRecord::Migration[8.1]
  def change
    create_table :portfolios do |t|
      t.bigint   :user_id,                 null: false
      t.string   :name,       limit: 120,  null: false
      t.string   :summary,    limit: 280,  null: false
      t.text     :thumbnail_url
      t.integer  :build_period_type,       null: false, comment: "0:weeks / 1:months / 2:range"
      t.integer  :build_period_value
      t.date     :build_started_on
      t.date     :build_ended_on
      t.text     :github_url
      t.text     :deploy_url
      t.text     :deploy_diagram_url
      t.text     :deploy_notes
      t.bigint   :target_category_id
      t.text     :interview_feedback_note
      t.integer  :status,                  null: false, default: 0, comment: "0:draft / 1:published"
      t.text     :other_notes
      t.datetime :published_at
      t.timestamps null: false
    end

    add_index :portfolios, :user_id
    add_index :portfolios, [ :status, :published_at ]
    add_foreign_key :portfolios, :users
    add_foreign_key :portfolios, :target_categories
  end
end
