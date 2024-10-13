class FitnessProfilesController < ApplicationController
  before_action :set_fitness_profile, only: %i[edit update]

  def new
    @fitness_profile = FitnessProfile.new
  end

  def show
    @fitness_profile = current_user.fitness_profile
  end

  def create
    @fitness_profile = current_user.build_fitness_profile(fitness_profile_params)
    if @fitness_profile.save
      redirect_to user_profile_path, notice: "Fitness profile created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @fitness_profile.update(fitness_profile_params)
      redirect_to user_profile_path, notice: "Fitness profile updated successfully."
    else
      render :edit
    end
  end

  private

  def set_fitness_profile
    @fitness_profile = current_user.fitness_profile || current_user.build_fitness_profile
  end


  def fitness_profile_params
    params.require(:fitness_profile).permit(:fitness_goals, :workout_types, :gender, :age_range_start, :age_range_end)
  end
end
