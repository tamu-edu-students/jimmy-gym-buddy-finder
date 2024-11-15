class CreateConversations < ActiveRecord::Migration[7.2]
  def change
    create_table :conversations do |t|
      t.references :user1, foreign_key: { to_table: :users }
      t.references :user2, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :conversations, [ :user1_id, :user2_id ], unique: true
  end
end
