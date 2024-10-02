class AddDetailsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :school, :string
    add_column :users, :major, :string
    add_column :users, :about_me, :text
  end
end
