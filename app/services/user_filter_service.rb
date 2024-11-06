# app/services/user_filter_service.rb
class UserFilterService
  def self.filter_prospective_users(user, prospective_users)
    fitness_profile = user.fitness_profile
    return [] if fitness_profile.nil?

    prospective_users.select do |prospective_user|
      prospective_fitness_profile = prospective_user.fitness_profile
      next unless prospective_fitness_profile

      meets_all_criteria?(fitness_profile, prospective_user, prospective_fitness_profile)
    end
  end

  private

  def self.meets_all_criteria?(fitness_profile, prospective_user, prospective_fitness_profile)
    criteria = [
      age_criteria(fitness_profile, prospective_user),
      gender_criteria(fitness_profile, prospective_user),
      gym_locations_criteria(fitness_profile, prospective_fitness_profile),
      activities_criteria(fitness_profile, prospective_fitness_profile),
      workout_schedule_criteria(fitness_profile, prospective_fitness_profile),
      workout_types_criteria(fitness_profile, prospective_fitness_profile)
    ]

    log_criteria_results(prospective_user, criteria)
    criteria.all?
  end

  def self.age_criteria(fitness_profile, prospective_user)
    prospective_user.age.between?(fitness_profile.age_range_start, fitness_profile.age_range_end)
  end

  def self.gender_criteria(fitness_profile, prospective_user)
    match_gender?(fitness_profile.gender_preferences, prospective_user.gender)
  end

  def self.gym_locations_criteria(fitness_profile, prospective_fitness_profile)
    match_gym_locations?(fitness_profile.gym_locations, prospective_fitness_profile.gym_locations)
  end

  def self.activities_criteria(fitness_profile, prospective_fitness_profile)
    match_activities?(fitness_profile.activities_with_experience, prospective_fitness_profile.activities_with_experience)
  end

  def self.workout_schedule_criteria(fitness_profile, prospective_fitness_profile)
    match_workout_schedule?(fitness_profile.workout_schedule, prospective_fitness_profile.workout_schedule)
  end

  def self.workout_types_criteria(fitness_profile, prospective_fitness_profile)
    match_workout_types?(fitness_profile.workout_types, prospective_fitness_profile.workout_types)
  end

  def self.match_gender?(gender_preferences, prospective_gender)
    # Split the gender preferences into an array
    preferences = gender_preferences.split(",") || []

    # Check if the prospective user's gender matches any of the preferences
    preferences.include?(prospective_gender) || preferences.include?("Any")
  end

  def self.match_gym_locations?(user_locations, prospective_locations)
    (user_locations.split(",") & prospective_locations.split(",")).any?
  end

  def self.match_activities?(user_activities, prospective_activities)
    # Extract activity names by splitting on the '|' character
    user_activity_names = user_activities.split("|").map { |activity| activity.split(":").first.strip }
    prospective_activity_names = prospective_activities.split("|").map { |activity| activity.split(":").first.strip }

    # Check if there's any overlap between the activity names
    (user_activity_names & prospective_activity_names).any?
  end

  def self.match_workout_schedule?(user_schedule, prospective_schedule)
    (user_schedule.split("|") & prospective_schedule.split("|")).any?
  end

  def self.match_workout_types?(user_types, prospective_types)
    (user_types.split(",") & prospective_types.split(",")).any?
  end

  def self.log_criteria_results(prospective_user, criteria)
    criteria_names = [ "Age", "Gender", "Gym locations", "Activities", "Workout schedule", "Workout types" ]
    criteria.each_with_index do |result, index|
      Rails.logger.info("#{criteria_names[index]} criteria for #{prospective_user.username}: #{result}")
    end
  end
end
