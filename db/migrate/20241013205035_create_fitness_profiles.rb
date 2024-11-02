class CreateFitnessProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :fitness_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :gender
      t.text :gender_preferences
      t.integer :age_range_start
      t.integer :age_range_end
      t.text :gym_locations  # Will store comma-separated values
      t.text :activities_with_experience  # Will store serialized data
      t.text :workout_schedule  # Will store serialized data
      t.text :workout_types  # Will store comma-separated values
      t.text :fitness_goals

      t.timestamps
    end
  end
end
