class UserMatchesController < ApplicationController
    # Existing method to get prospective users
    def prospective_users
      user = User.find(params[:id])
      prospective_users = User.where.not(id: user.id)
  
      render json: prospective_users, status: :ok
    end
  
    # Match a prospective user
    def match
      user = User.find(params[:user_id])
      prospective_user = User.find(params[:prospective_user_id])
  
      # Create or update the user match entry
      user_match = UserMatch.find_or_initialize_by(user_id: user.id, prospective_user_id: prospective_user.id)
      user_match.status = 'matched'
      user_match.save!
  
      # Optionally, you might want to create a reciprocal match
      reciprocal_match = UserMatch.find_or_initialize_by(user_id: prospective_user.id, prospective_user_id: user.id)
      reciprocal_match.status = 'matched'
      reciprocal_match.save!
  
      render json: { message: 'Matched successfully.' }, status: :ok
    end
  
    # Skip a prospective user
    def skip
      user = User.find(params[:user_id])
      prospective_user = User.find(params[:prospective_user_id])
  
      # Create or update the user match entry
      user_match = UserMatch.find_or_initialize_by(user_id: user.id, prospective_user_id: prospective_user.id)
      user_match.status = 'skipped'
      user_match.save!
  
      render json: { message: 'Skipped successfully.' }, status: :ok
    end
  
    # Block a prospective user
    def block
      user = User.find(params[:user_id])
      prospective_user = User.find(params[:prospective_user_id])
  
      # Create or update the user match entry
      user_match = UserMatch.find_or_initialize_by(user_id: user.id, prospective_user_id: prospective_user.id)
      user_match.status = 'blocked'
      user_match.save!
  
      render json: { message: 'Blocked successfully.' }, status: :ok
    end
  end
  