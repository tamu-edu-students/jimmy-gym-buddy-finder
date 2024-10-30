# spec/factories/fitness_profiles.rb
FactoryBot.define do
  factory :fitness_profile do
    association :user
    age_range_start { 20 }
    age_range_end { 30 }
    gym_locations { ["Downtown Gym"] }
    workout_types { ["Strength Training", "Cardio"] }
    gender_preferences { "Male,Female" } # Default gender preferences
  end
end
