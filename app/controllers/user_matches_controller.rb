class UserMatchesController < ApplicationController
    # Existing method to get prospective users
    def prospective_users
      current_user_id = params[:id]

      # Find all users who aren’t matched, skipped, or blocked for the given user
      # This avoids the need for complex joins or includes which can cause circular references
      prospective_users = User.where.not(id: current_user_id)
                              .where.not(id: UserMatch.select(:prospective_user_id)
                                                       .where(user_id: current_user_id))
  
      render json: prospective_users
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
  