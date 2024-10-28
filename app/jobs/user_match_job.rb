# app/jobs/user_match_job.rb
class UserMatchJob < ApplicationJob
  queue_as :default

  def perform(user)
    # Logic to find prospective users for the new user
    prospective_users = User.where.not(id: user.id)

    # Create entries in the UserMatch table with "new" status
    prospective_users.each do |prospective_user|
      # Create match for the new user
      UserMatch.find_or_create_by(user_id: user.id, prospective_user_id: prospective_user.id) do |match|
        match.status = 'new'
      end

      # Create reciprocal match if it doesn't already exist
      UserMatch.find_or_create_by(user_id: prospective_user.id, prospective_user_id: user.id) do |reciprocal_match|
        reciprocal_match.status = 'new'
      end
    end
  end
end
