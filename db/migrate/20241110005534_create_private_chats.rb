class CreatePrivateChats < ActiveRecord::Migration[7.2]
  def change
    create_table :private_chats do |t|
      t.references :profile1, null: false, foreign_key: { to_table: :profiles }
      t.references :profile2, null: false, foreign_key: { to_table: :profiles }

      t.timestamps
    end
  end
end
