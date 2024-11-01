class UserMatchesController < ApplicationController
  before_action :require_login

    # Existing method to get prospective users
    def prospective_users
      user_id = params[:id]

      new_user_ids = UserMatch.where(user_id: user_id, status: "new").pluck(:prospective_user_id)
      skipped_user_ids = UserMatch.where(user_id: user_id, status: "skipped").pluck(:prospective_user_id)

      # Combine IDs in the desired order (new first, then skipped)
      ordered_ids = new_user_ids + skipped_user_ids

      # Fetch users based on the combined ID list
      prospective_users = User.where(id: ordered_ids).select(:id, :username, :email, :age, :gender)

      # Filter prospective users based on fitness profile criteria
      filtered_users = filter_prospective_users(user, prospective_users)

      # Sort users based on the original ordered_ids to maintain the correct order
      sorted_prospective_users = ordered_ids.map do |id|
        filtered_users.find { |user| user.id == id }
      end.compact # Remove nil values if there are any IDs not found

      render json: sorted_prospective_users
    end

    # Match a prospective user
    def match
      user = User.find(params[:user_id])
      prospective_user = User.find(params[:prospective_user_id])

      if user.id == prospective_user.id
        render json: { error: "You cannot match yourself." }, status: :unprocessable_entity
        return
      end

      # Create or update the user match entry
      user_match = UserMatch.find_or_initialize_by(user_id: user.id, prospective_user_id: prospective_user.id)
      user_match.status = "matched"

      if user_match.save
        # Check if the other user has also matched the current user
        reciprocal_match = UserMatch.find_by(user_id: prospective_user.id, prospective_user_id: user.id, status: "matched")

        if reciprocal_match
          # Create notifications for both users
          Notification.create(user: user, matched_user: prospective_user, read: false)
          Notification.create(user: prospective_user, matched_user: user, read: false)
        end

        render json: { message: "Matched successfully." }, status: :ok
      else
        render json: { error: "Failed to match." }, status: :unprocessable_entity
      end
    end

    # Skip a prospective user
    def skip
      user = User.find(params[:user_id])
      prospective_user = User.find(params[:prospective_user_id])

      if user.id == prospective_user.id
        render json: { error: "You cannot skip yourself." }, status: :unprocessable_entity
        return
      end

      # Create or update the user match entry
      user_match = UserMatch.find_or_initialize_by(user_id: user.id, prospective_user_id: prospective_user.id)
      user_match.status = "skipped"

      if user_match.save
        render json: { message: "Skipped successfully." }, status: :ok
      else
        render json: { error: "Failed to skip." }, status: :unprocessable_entity
      end
    end

    # Block a prospective user
    def block
      user = User.find(params[:user_id])
      prospective_user = User.find(params[:prospective_user_id])

      if user.id == prospective_user.id
        render json: { error: "You cannot block yourself." }, status: :unprocessable_entity
        return
      end

      # Create or update the user match entry
      user_match = UserMatch.find_or_initialize_by(user_id: user.id, prospective_user_id: prospective_user.id)
      user_match.status = "blocked"

      if user_match.save
        render json: { message: "Blocked successfully." }, status: :ok
      else
        render json: { error: "Failed to block." }, status: :unprocessable_entity
      end
    end

    private

    def filter_prospective_users(user, prospective_users)
        fitness_profile = user.fitness_profile

        prospective_users.select do |prospective_user|
        prospective_fitness_profile = prospective_user.fitness_profile
        next unless prospective_fitness_profile

        # Apply filtering criteria
        age_criteria = prospective_user.age.between?(fitness_profile.age_range_start, fitness_profile.age_range_end)
        Rails.logger.info("Age criteria for #{prospective_user.username}: #{age_criteria}")

        gender_criteria = match_gender?(fitness_profile.gender_preferences, prospective_user.gender)
        Rails.logger.info("Gender criteria for #{prospective_user.username}: #{gender_criteria}")

        gym_locations_criteria = match_gym_locations?(fitness_profile.gym_locations, prospective_fitness_profile.gym_locations)
        Rails.logger.info("Gym locations criteria for #{prospective_user.username}: #{gym_locations_criteria}")

        activities_criteria = match_activities?(fitness_profile.activities_with_experience, prospective_fitness_profile.activities_with_experience)
        Rails.logger.info("Activities criteria for #{prospective_user.username}: #{activities_criteria}")

        workout_schedule_criteria = match_workout_schedule?(fitness_profile.workout_schedule, prospective_fitness_profile.workout_schedule)
        Rails.logger.info("Workout schedule criteria for #{prospective_user.username}: #{workout_schedule_criteria}")

        workout_types_criteria = match_workout_types?(fitness_profile.workout_types, prospective_fitness_profile.workout_types)
        Rails.logger.info("Workout types criteria for #{prospective_user.username}: #{workout_types_criteria}")

        # All criteria must be satisfied
        age_criteria && gender_criteria && gym_locations_criteria &&
        activities_criteria && workout_schedule_criteria && workout_types_criteria
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
end
