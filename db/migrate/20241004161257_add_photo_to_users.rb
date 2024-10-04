class AddPhotoToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :photo, :string
  end
end
