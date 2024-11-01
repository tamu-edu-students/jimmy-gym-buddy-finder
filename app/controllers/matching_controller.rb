class MatchingController < ApplicationController
    def profileswipe
      @user_id = params[:user_id] # Get the user_id from the URL parameters
      user_matches_controller = UserMatchesController.new
      user_matches_controller.request = request
      user_matches_controller.response = response
  
      # Call the prospective_users method
      @prospective_users = user_matches_controller.prospective_users
      Rails.logger.info(@prospective_users)
  
      render 'profileswipe'
    end
  end