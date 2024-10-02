class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "User successfully registered!"
    else
      render :new
    end
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

end
