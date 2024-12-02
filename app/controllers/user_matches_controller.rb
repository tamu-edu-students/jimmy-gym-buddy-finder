class UserMatchesController < ApplicationController
  before_action :require_login

  def prospective_users
    user_id = params[:user_id]
    log_user_info(user_id)

    ordered_ids = fetch_prospective_user_ids(user_id)
    filtered_users = fetch_and_filter_user_data(ordered_ids)
    sorted_prospective_users = organize_user_response(filtered_users, ordered_ids)

    @prospective_users = sorted_prospective_users
    respond_to_request
  end

  def matched_users
    user_id = params[:user_id]
    log_user_info(user_id)

    @current_user = current_user
    @matched_users = fetch_matched_users(user_id)

    if request.format.json?
      render json: @matched_users
    else
      @matched_users
    end
  end

  def match
    result = MatchingService.perform_action("match", current_user, prospective_user)
    MatchingService.check_reciprocal_match(current_user, prospective_user) if result[:status] == :ok
    render json: result, status: result[:status]
  end

  def skip
    result = MatchingService.perform_action("skip", current_user, prospective_user)
    render json: result, status: result[:status]
  end

  def block
    result = MatchingService.perform_action("block", current_user, prospective_user)
    render json: result, status: result[:status]
  end

  def block_from_profile
    result = MatchingService.perform_action("block", current_user, prospective_user)
    redirect_to matched_users_path(@user), notice: "User has been blocked.", status: :see_other
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
    UserFilterService.filter_prospective_users(current_user, prospective_users)
  end

  def organize_user_response(filtered_users, ordered_ids)
    ordered_ids.map { |id| build_user_data(filtered_users, id) }.compact
  end

  def fetch_matched_users(user_id)
    matched_user_ids = UserMatch.where(user_id: user_id, status: "matched").pluck(:prospective_user_id)
    prospective_user_ids = UserMatch.where(prospective_user_id: user_id, status: "matched").pluck(:user_id)

    # Get the intersection of both lists to find bidirectional matches
    bidirectional_matched_ids = matched_user_ids & prospective_user_ids

    User.where(id: bidirectional_matched_ids).select(:id, :username, :email, :age, :gender)
  end

  def respond_to_request
    if request.format.json?
      render json: @prospective_users
    else
      @prospective_users
    end
  end

  def build_user_data(filtered_users, id)
    user = filtered_users.find { |u| u.id == id }
    return nil unless user

    user_data = user.as_json(only: [ :id, :username, :email, :age, :gender, :photo ])
    add_fitness_profile_data(user_data, user)
    user_data
  end

  def add_fitness_profile_data(user_data, user)
    if user.fitness_profile
      user_data["fitness_profile"] = user.fitness_profile.as_json(only: [ :activities_with_experience, :gym_locations, :workout_schedule, :workout_types ])
    end
  end

  def current_user
    @current_user ||= User.find(params[:user_id])
  end

  def prospective_user
    @prospective_user ||= User.find(params[:prospective_user_id])
  end
end
