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
      flash.now[:alert] = "There were errors while updating the profile. Please check the fields and try again."
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def update_user_params
    params.require(:user).permit(:photo, :username, :age, :gender, :school, :major, :about_me)
  end
end
