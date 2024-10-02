class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to profile_user_path(@user), notice: "Profile successfully updated!"
    else
      render :edit
    end
  end
  private

  def user_params
    params.require(:user).permit(:name, :age, :gender, :school, :major, :about_me)
  end
  
  def new
    @user = User.new # Initializes a new user instance for the form
  end

  def create
    @user = User.new(user_params) # Create a new user with the submitted params

    if @user.save
      flash[:notice] = "User registered successfully."
      redirect_to new_user_path
    else
      flash.now[:alert] = "There were errors while saving the user."
      render :new # This re-renders the new form
    end
  end

  private
end
