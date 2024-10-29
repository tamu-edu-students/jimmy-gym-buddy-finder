class UserMatchesController < ApplicationController

  before_action :require_login

    # Existing method to get prospective users
    def prospective_users
      user_id = params[:id]
  
      new_user_ids = UserMatch.where(user_id: user_id, status: 'new').pluck(:prospective_user_id)
      skipped_user_ids = UserMatch.where(user_id: user_id, status: 'skipped').pluck(:prospective_user_id)
      
      # Combine IDs in the desired order (new first, then skipped)
      ordered_ids = new_user_ids + skipped_user_ids

      # Fetch users based on the combined ID list
      prospective_users = User.where(id: ordered_ids).select(:id, :username, :email)

      # Sort users based on the original ordered_ids to maintain the correct order
      sorted_prospective_users = ordered_ids.map do |id|
        prospective_users.find { |user| user.id == id }
      end.compact # Remove nil values if there are any IDs not found

      render json: sorted_prospective_users
    end
  
    # Match a prospective user
    def match
      user = User.find(params[:user_id])
      prospective_user = User.find(params[:prospective_user_id])

      if user.id == prospective_user.id
        render json: { error: "You cannot match yourself." }, status: :unprocessable_entity
        return
      end
    
      # Create or update the user match entry
      user_match = UserMatch.find_or_initialize_by(user_id: user.id, prospective_user_id: prospective_user.id)
      user_match.status = 'matched'
    
      if user_match.save
        # Check if the other user has also matched the current user
        reciprocal_match = UserMatch.find_by(user_id: prospective_user.id, prospective_user_id: user.id, status: 'matched')
    
        if reciprocal_match
          # Create notifications for both users
          Notification.create(user: user, matched_user: prospective_user, read: false)
          Notification.create(user: prospective_user, matched_user: user, read: false)
        end
    
        render json: { message: 'Matched successfully.' }, status: :ok
      else
        render json: { error: 'Failed to match.' }, status: :unprocessable_entity
      end
    end
  
    # Skip a prospective user
    def skip
      user = User.find(params[:user_id])
      prospective_user = User.find(params[:prospective_user_id])

      if user.id == prospective_user.id
        render json: { error: "You cannot skip yourself." }, status: :unprocessable_entity
        return
      end
    
      # Create or update the user match entry
      user_match = UserMatch.find_or_initialize_by(user_id: user.id, prospective_user_id: prospective_user.id)
      user_match.status = 'skipped'
    
      if user_match.save
        render json: { message: 'Skipped successfully.' }, status: :ok
      else
        render json: { error: 'Failed to skip.' }, status: :unprocessable_entity
      end
    end
  
    # Block a prospective user
    def block
      user = User.find(params[:user_id])
      prospective_user = User.find(params[:prospective_user_id])

      if user.id == prospective_user.id
        render json: { error: "You cannot block yourself." }, status: :unprocessable_entity
        return
      end
    
      # Create or update the user match entry
      user_match = UserMatch.find_or_initialize_by(user_id: user.id, prospective_user_id: prospective_user.id)
      user_match.status = 'blocked'
    
      if user_match.save
        render json: { message: 'Blocked successfully.' }, status: :ok
      else
        render json: { error: 'Failed to block.' }, status: :unprocessable_entity
      end
    end
  end
  