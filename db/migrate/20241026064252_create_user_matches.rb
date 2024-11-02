class CreateUserMatches < ActiveRecord::Migration[7.2]
  def change
    create_table :user_matches do |t|
      t.integer :user_id, null: false
      t.integer :prospective_user_id, null: false
      t.string :status, null: false  # status can be 'new', 'matched', 'blocked', 'skipped'

      # No need to manually define created_at; it's included with t.timestamps
      t.timestamps  # This will add created_at and updated_at automatically

      t.index [ :user_id, :prospective_user_id ], unique: true, name: 'index_user_matches_on_user_and_prospective_user'
      t.index :prospective_user_id, name: 'index_user_matches_on_prospective_user_id'
    end

    add_foreign_key :user_matches, :users, column: :user_id
    add_foreign_key :user_matches, :users, column: :prospective_user_id
  end
end
