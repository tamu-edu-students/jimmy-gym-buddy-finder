class UserMatchesController < ApplicationController
  before_action :require_login

    # Existing method to get prospective users
    def prospective_users
      user_id = params[:user_id]
      log_user_info(user_id)
    
      ordered_ids = fetch_prospective_user_ids(user_id)
      filtered_users = fetch_and_filter_user_data(ordered_ids)
      sorted_prospective_users = organize_user_response(filtered_users, ordered_ids)
    
      @prospective_users = sorted_prospective_users
      respond_to_request
    end
    
    # Match a prospective user
    def match
      perform_action("match") do |user_match, user, prospective_user|
        check_reciprocal_match(user_match, user, prospective_user)
      end
    end
    
    def skip
      perform_action("skip")
    end
    
    def block
      perform_action("block")
    end
    private
    
    def log_user_info(user_id)
      Rails.logger.info(user_id)
    end
    
    def fetch_prospective_user_ids(user_id)
      new_user_ids = UserMatch.where(user_id: user_id, status: "new").pluck(:prospective_user_id)
      skipped_user_ids = UserMatch.where(user_id: user_id, status: "skipped").pluck(:prospective_user_id)
      Rails.logger.info(new_user_ids)
      Rails.logger.info(skipped_user_ids)
      new_user_ids + skipped_user_ids
    end
    
    def fetch_and_filter_user_data(ordered_ids)
      prospective_users = User.where(id: ordered_ids).select(:id, :username, :email, :age, :gender)
      filter_prospective_users(user, prospective_users)
    end
    
    def organize_user_response(filtered_users, ordered_ids)
      ordered_ids.map do |id|
        user = filtered_users.find { |u| u.id == id }
        next unless user
        user_data = user.as_json(only: [:id, :username, :email, :age, :gender, :photo])
        user_data["fitness_profile"] = user.fitness_profile.as_json(only: [:activities_with_experience, :gym_locations, :workout_schedule, :workout_types]) if user.fitness_profile
        user_data
      end.compact
    end
    
    def respond_to_request
      if request.format.json?
        render json: @prospective_users
      else
        @prospective_users
      end
    end

    def filter_prospective_users(user, prospective_users)
      fitness_profile = user.fitness_profile
      return [] if fitness_profile.nil?

      prospective_users.select do |prospective_user|
        prospective_fitness_profile = prospective_user.fitness_profile
        next unless prospective_fitness_profile

        meets_all_criteria?(fitness_profile, prospective_user, prospective_fitness_profile)
      end
    end

    def meets_all_criteria?(fitness_profile, prospective_user, prospective_fitness_profile)
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

    def age_criteria(fitness_profile, prospective_user)
      prospective_user.age.between?(fitness_profile.age_range_start, fitness_profile.age_range_end)
    end

    def gender_criteria(fitness_profile, prospective_user)
      match_gender?(fitness_profile.gender_preferences, prospective_user.gender)
    end

    def gym_locations_criteria(fitness_profile, prospective_fitness_profile)
      match_gym_locations?(fitness_profile.gym_locations, prospective_fitness_profile.gym_locations)
    end

    def activities_criteria(fitness_profile, prospective_fitness_profile)
      match_activities?(fitness_profile.activities_with_experience, prospective_fitness_profile.activities_with_experience)
    end

    def workout_schedule_criteria(fitness_profile, prospective_fitness_profile)
      match_workout_schedule?(fitness_profile.workout_schedule, prospective_fitness_profile.workout_schedule)
    end

    def workout_types_criteria(fitness_profile, prospective_fitness_profile)
      match_workout_types?(fitness_profile.workout_types, prospective_fitness_profile.workout_types)
    end

    def log_criteria_results(prospective_user, criteria)
      criteria_names = ['Age', 'Gender', 'Gym locations', 'Activities', 'Workout schedule', 'Workout types']
      criteria.each_with_index do |result, index|
        Rails.logger.info("#{criteria_names[index]} criteria for #{prospective_user.username}: #{result}")
      end
    end

    def match_gender?(gender_preferences, prospective_gender)
      # Split the gender preferences into an array
      preferences = gender_preferences.split(",") || []

      # Check if the prospective user's gender matches any of the preferences
      preferences.include?(prospective_gender) || preferences.include?("Any")
    end

    def match_gym_locations?(user_locations, prospective_locations)
      (user_locations.split(",") & prospective_locations.split(",")).any?
    end

    def match_activities?(user_activities, prospective_activities)
      # Extract activity names by splitting on the '|' character
      user_activity_names = user_activities.split("|").map { |activity| activity.split(":").first.strip }
      prospective_activity_names = prospective_activities.split("|").map { |activity| activity.split(":").first.strip }

      # Check if there's any overlap between the activity names
      (user_activity_names & prospective_activity_names).any?
    end

    def match_workout_schedule?(user_schedule, prospective_schedule)
      (user_schedule.split("|") & prospective_schedule.split("|")).any?
    end

    def match_workout_types?(user_types, prospective_types)
      (user_types.split(",") & prospective_types.split(",")).any?
    end

    def perform_action(action)
      user = User.find(params[:user_id])
      prospective_user = User.find(params[:prospective_user_id])
    
      if user.id == prospective_user.id
        render json: { error: "You cannot #{action} yourself." }, status: :unprocessable_entity
        return
      end
    
      user_match = UserMatch.find_or_initialize_by(user_id: user.id, prospective_user_id: prospective_user.id)
      user_match.status = past_tense(action)
    
      if user_match.save
        yield(user_match, user, prospective_user) if block_given?
        render json: { message: "#{past_tense(action).capitalize} successfully." }, status: :ok
      else
        render json: { error: "Failed to #{action}." }, status: :unprocessable_entity
      end
    end
    
    def past_tense(verb)
      case verb
      when 'skip'
        'skipped'
      when 'match'
        'matched'
      when 'block'
        'blocked'
      else
        verb + 'ed'
      end
    end
  
    def check_reciprocal_match(user_match, user, prospective_user)
      reciprocal_match = UserMatch.find_by(user_id: prospective_user.id, prospective_user_id: user.id, status: "matched")
      if reciprocal_match
        Notification.create(user: user, matched_user: prospective_user, read: false)
        Notification.create(user: prospective_user, matched_user: user, read: false)
      end
    end
end
