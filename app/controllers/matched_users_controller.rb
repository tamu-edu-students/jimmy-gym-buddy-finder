class MatchedUsersController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @matched_user = User.find(params[:id])
    # Add any additional logic needed for the profile page
  end
end