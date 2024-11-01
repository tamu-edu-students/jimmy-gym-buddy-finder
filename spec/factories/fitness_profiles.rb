
# spec/factories/fitness_profiles.rb
FactoryBot.define do
  factory :fitness_profile do
    age_range_start { 25 }
    age_range_end { 35 }
    gender_preferences { "Male,Female" }
    gym_locations { ["Downtown Gym"] }
    workout_types { ["Strength Training", "Cardio"] }
    activities_with_experience { "Running:Intermediate|Swimming:Beginner" }
    workout_schedule { "Morning=06:00-08:00|Evening=18:00-20:00" }
    user
  end
end