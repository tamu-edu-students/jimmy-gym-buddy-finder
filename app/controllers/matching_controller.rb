class MatchingController < ApplicationController
  def profileswipe
    @user_id = params[:user_id]
    user_matches_controller = UserMatchesController.new
    user_matches_controller.request = request
    user_matches_controller.response = response

    @prospective_users = UserMatchesController.get_prospective_users(@user_id)
    respond_to do |format|
      format.html { render 'profileswipe' }
      format.json { render json: @prospective_users }
    end
  end
end
