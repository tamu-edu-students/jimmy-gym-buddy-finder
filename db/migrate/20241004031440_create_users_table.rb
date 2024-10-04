class CreateUsersTable < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.string :gender
      t.string :school
      t.string :major
      t.text :about_me
      t.string :uid
      t.string :provider

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
