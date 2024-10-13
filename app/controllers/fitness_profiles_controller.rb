class FitnessProfilesController < ApplicationController
  before_action :set_fitness_profile, only: [ :show, :edit, :update ]
  before_action :set_user

  def new
    @fitness_profile = @user.build_fitness_profile
  end

  def create
    if @user.fitness_profile.nil?
      @fitness_profile = @user.build_fitness_profile(fitness_profile_params)
      if @fitness_profile.save
        flash[:notice] = "Fitness profile created successfully."
        redirect_to fitness_profile_path(@fitness_profile)
      else
        render :new
      end
    else
      redirect_to fitness_profile_path(@user.fitness_profile), notice: "Fitness profile already exists."
    end
  end

  def show
  end

  def edit
  end

  def update
    if @fitness_profile.update(fitness_profile_params)
      redirect_to user_fitness_profile_path(@user, @fitness_profile), notice: "Fitness profile updated successfully."
    else
      render :edit
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
    params.require(:fitness_profile).permit(:fitness_goals, :workout_types, :gender, :age_range_start, :age_range_end)
  end
end
