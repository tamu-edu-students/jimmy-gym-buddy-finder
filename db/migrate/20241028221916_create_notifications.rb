class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true  # User receiving the notification
      t.references :matched_user, null: false, foreign_key: { to_table: :users }  # User who caused the notification
      t.boolean :read, default: false  # Default to false for unread notifications

      t.timestamps
    end
  end
end
