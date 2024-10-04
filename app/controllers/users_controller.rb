class UsersController < ApplicationController
  skip_before_action :check_profile_completion, only: [ :edit, :update ]

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(update_user_params)
      if @user.valid?(:profile_update)
        redirect_to profile_user_path(@user), notice: "Profile successfully updated and is complete!"
      else
        flash.now[:alert] = "Profile is incomplete. Please fill in all required fields."
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "There were errors while updating the profile. Please check the fields and try again."
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new # Initializes a new user instance for the form
  end

  def create
    @user = User.new(create_user_params) # Create a new user with the submitted params
    if @user.save
      flash[:notice] = "User registered successfully."
      redirect_to dashboard_user_path(@user)
    else
      flash.now[:alert] = "There were errors while saving the user."
      render :new, status: :unprocessable_entity  # Important: this tells Turbo the form is invalid
    end
  end

  private
  def create_user_params
    params.require(:user).permit(:first_name, :last_name, :age, :gender)
  end

  def update_user_params
    params.require(:user).permit(:username, :age, :gender, :school, :major, :about_me)
  end
end
