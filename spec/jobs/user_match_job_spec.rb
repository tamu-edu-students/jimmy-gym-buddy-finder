# spec/jobs/user_match_job_spec.rb
require 'rails_helper'

RSpec.describe UserMatchJob, type: :job do
  let!(:user) { create(:user) }
  let!(:prospective_user1) { create(:user) }
  let!(:prospective_user2) { create(:user) }

  it 'creates matches for each prospective user with the "new" status' do
    UserMatchJob.perform_now(user)
    expect(UserMatch.where(user_id: user.id, status: 'new').pluck(:prospective_user_id)).to contain_exactly(prospective_user1.id, prospective_user2.id)
  end

  it 'creates reciprocal matches for each prospective user with the "new" status' do
    UserMatchJob.perform_now(user)
    expect(UserMatch.where(user_id: prospective_user1.id, prospective_user_id: user.id, status: 'new')).to exist
    expect(UserMatch.where(user_id: prospective_user2.id, prospective_user_id: user.id, status: 'new')).to exist
  end

  it 'does not create a match for the user with themselves' do
    UserMatchJob.perform_now(user)
    expect(UserMatch.where(user_id: user.id, prospective_user_id: user.id)).not_to exist
  end

  it 'does not duplicate existing matches' do
    UserMatch.create!(user_id: user.id, prospective_user_id: prospective_user1.id, status: 'new')
    expect {
      UserMatchJob.perform_now(user)
    }.not_to change { UserMatch.where(user_id: user.id, prospective_user_id: prospective_user1.id).count }
  end
end
