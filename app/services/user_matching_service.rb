# app/services/user_matching_service.rb
class UserMatchingService
    def initialize(user)
      @user = user
    end
  
    def fetch_prospective_users
      ordered_ids = fetch_prospective_user_ids
      filtered_users = fetch_and_filter_user_data(ordered_ids)
      organize_user_response(filtered_users, ordered_ids)
    end
  
    private
  
    def fetch_prospective_user_ids
      new_user_ids = UserMatch.where(user_id: @user.id, status: "new").pluck(:prospective_user_id)
      skipped_user_ids = UserMatch.where(user_id: @user.id, status: "skipped").pluck(:prospective_user_id)
      new_user_ids + skipped_user_ids
    end
  
    def fetch_and_filter_user_data(ordered_ids)
      prospective_users = User.where(id: ordered_ids).select(:id, :username, :email, :age, :gender)
      UserFilteringService.new(@user).filter_prospective_users(prospective_users)
    end
  
    def organize_user_response(filtered_users, ordered_ids)
      ordered_ids.map { |id| build_user_data(filtered_users, id) }.compact
    end
  
    def build_user_data(filtered_users, id)
      user = filtered_users.find { |u| u.id == id }
      return nil unless user
  
      user_data = user.as_json(only: [:id, :username, :email, :age, :gender, :photo])
      add_fitness_profile_data(user_data, user)
      user_data
    end
  
    def add_fitness_profile_data(user_data, user)
      if user.fitness_profile
        user_data["fitness_profile"] = user.fitness_profile.as_json(only: [:activities_with_experience, :gym_locations, :workout_schedule, :workout_types])
      end
    end
  end