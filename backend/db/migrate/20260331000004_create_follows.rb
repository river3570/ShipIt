class CreateFollows < ActiveRecord::Migration[8.1]
  def change
    create_table :follows do |t|
      t.bigint :follower_id, null: false
      t.bigint :followee_id, null: false
      t.datetime :created_at, null: false
    end

    add_index :follows, [ :follower_id, :followee_id ], unique: true
    add_index :follows, :followee_id
    add_foreign_key :follows, :users, column: :follower_id
    add_foreign_key :follows, :users, column: :followee_id

    # 自己フォロー禁止
    reversible do |dir|
      dir.up do
        execute <<~SQL
          ALTER TABLE follows ADD CONSTRAINT chk_no_self_follow CHECK (follower_id <> followee_id);
        SQL
      end
      dir.down do
        execute "ALTER TABLE follows DROP CONSTRAINT chk_no_self_follow;"
      end
    end
  end
end
