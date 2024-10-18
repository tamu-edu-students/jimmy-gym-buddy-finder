class UsersController < ApplicationController
  skip_before_action :check_profile_completion, only: [ :edit, :update ]

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
      if @user.errors[:photo].include?("must be less than 500KB in size.")
        flash.now[:alert] = "Photo must be less than 500KB in size."
      elsif @user.errors[:photo].include?("must be a JPEG, JPG, GIF, or PNG.")
        flash.now[:alert] = "Photo must be a JPEG, JPG, GIF, or PNG."
      else
      end
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def update_user_params
    params.require(:user).permit(:photo, :username, :age, :gender, :school, :major, :about_me)
  end
end
