class FitnessProfilesController < ApplicationController
  before_action :set_fitness_profile, only: [ :show, :edit, :update ]
  before_action :set_user

  def new
    @fitness_profile = @user.build_fitness_profile
  end

  def create
    @fitness_profile = @user.build_fitness_profile(fitness_profile_params)

    if @fitness_profile.save
      redirect_to user_fitness_profile_path(@user), notice: "Fitness profile created successfully."
    end
  end

  def show
  end

  def edit
  end

  def update
    if @fitness_profile.update(fitness_profile_params)
      redirect_to user_fitness_profile_path(@user), notice: "Fitness profile updated successfully."
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_fitness_profile
    @fitness_profile = @user.fitness_profile
  end

  def fitness_profile_params
    profile_params = params.require(:fitness_profile).permit(
      :age_range_start,
      :age_range_end,
      :fitness_goals,
      :workout_schedule,  # Change this to permit the raw string
      gender_preferences: [],
      workout_types: [],
      gym_locations: [],
      activities_with_experience: []
    )

    # Serialize gender preferences
    profile_params[:gender_preferences] = profile_params[:gender_preferences].join(",") if profile_params[:gender_preferences].present?

    # Serialize workout types
    profile_params[:workout_types] = profile_params[:workout_types].join(",") if profile_params[:workout_types].present?

    # Serialize gym locations
    profile_params[:gym_locations] = profile_params[:gym_locations].join(",") if profile_params[:gym_locations].present?

    # Serialize activities with experience
    if profile_params[:activities_with_experience].present?
      activities = profile_params[:activities_with_experience].map do |activity_string|
        activity, experience = activity_string.split(":")
        "#{activity}:#{experience}"
      end
      profile_params[:activities_with_experience] = activities.join("|")
    end

    # The workout_schedule is already formatted correctly from the form
    profile_params
  end
end
