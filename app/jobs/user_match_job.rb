# app/jobs/user_match_job.rb
class UserMatchJob < ApplicationJob
  queue_as :default

  def perform(user)
    # Logic to find prospective users for the new user
    prospective_users = User.where.not(id: user.id)

    # Create entries in the UserMatch table with "new" status
    prospective_users.each do |prospective_user|
      UserMatch.create(user_id: user.id, prospective_user_id: prospective_user.id, status: 'new')
      UserMatch.create(user_id: prospective_user.id, prospective_user_id: user.id, status: 'new')
    end
  end
end
