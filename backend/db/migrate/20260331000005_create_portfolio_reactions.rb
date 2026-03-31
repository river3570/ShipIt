class CreatePortfolioReactions < ActiveRecord::Migration[8.1]
  def change
    create_table :portfolio_reactions do |t|
      t.bigint   :user_id,      null: false
      t.bigint   :portfolio_id, null: false
      t.datetime :created_at,   null: false
    end

    add_index :portfolio_reactions, [ :user_id, :portfolio_id ], unique: true
    add_index :portfolio_reactions, :portfolio_id
    add_foreign_key :portfolio_reactions, :users
    add_foreign_key :portfolio_reactions, :portfolios
  end
end
