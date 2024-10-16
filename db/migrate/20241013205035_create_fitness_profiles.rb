class CreateFitnessProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :fitness_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :fitness_goals
      t.string :workout_types
      t.string :gender
      t.string :age_range_start
      t.string :age_range_end

      t.timestamps
    end
  end
end
