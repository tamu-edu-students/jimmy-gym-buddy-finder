require 'rails_helper'

RSpec.describe UserMatchesController, type: :controller do
  let(:user) { FactoryBot.create(:user, :complete_profile) }
  let(:prospective_user) { FactoryBot.create(:user, :complete_profile) }
  let(:fitness_profile) { user.fitness_profile }

  before do
    request.env['omniauth.auth'] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: user.email,
        name: user.username
      },
      credentials: {
        token: 'mock_token',
        refresh_token: 'mock_refresh_token',
        expires_at: Time.now + 1.week
      }
    })
    session[:user_id] = user.id

    user.fitness_profile.update!(
      age_range_start: 25,
      age_range_end: 35,
      gender_preferences: "Female,Non-binary",
      gym_locations: "Gym A,Gym B",
      activities_with_experience: "Running:Intermediate|Swimming:Beginner",
      workout_schedule: "Monday=06:00-08:00|Wednesday=06:00-08:00|Friday=06:00-08:00",
      workout_types: "Cardio,Strength"
    )

    # Set up prospective user's fitness profile
    prospective_user.update!(age: 30, gender: "Female")
    prospective_user.fitness_profile.update!(
      age_range_start: 20,
      age_range_end: 40,
      gender_preferences: "Female",
      gym_locations: "Gym A,Gym C",
      activities_with_experience: "Running:Intermediate|Yoga:Beginner",
      workout_schedule: "Monday=06:00-08:00|Tuesday=06:00-08:00|Thursday=06:00-08:00|Saturday=06:00-08:00",
      workout_types: "Cardio,Yoga"
    )
  end

  describe 'GET #prospective_users' do
    context 'when prospective users are available' do
      it 'returns sorted prospective users' do
        UserMatch.create!(user_id: user.id, prospective_user_id: prospective_user.id, status: 'new')
        
        get :prospective_users, params: { user_id: user.id }
        
        expect(response).to have_http_status(:success)
        
        # Check if the instance variable is populated correctly
        prospective_users = assigns(:prospective_users)
        expect(prospective_users).not_to be_empty
        expect(prospective_users.first['id']).to eq(prospective_user.id)
      end
    end

    context 'when no prospective users are available' do
      it 'returns an empty array' do
        get :prospective_users, params: { user_id: user.id }
        
        expect(response).to have_http_status(:success)
        
        # Check if the instance variable is empty
        prospective_users = assigns(:prospective_users)
        expect(prospective_users).to eq([])
      end
    end
  end

  describe 'POST #match' do
    context 'when user attempts to match with a prospective user' do
      it 'creates a matched status for the user match' do
        post :match, params: { user_id: user.id, prospective_user_id: prospective_user.id }
        expect(response).to be_successful
        user_match = UserMatch.find_by(user_id: user.id, prospective_user_id: prospective_user.id)
        expect(user_match.status).to eq('matched')
      end

      it 'returns an error if user tries to match with themselves' do
        post :match, params: { user_id: user.id, prospective_user_id: user.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('You cannot match yourself.')
      end

      it 'creates notifications when there is a reciprocal match' do
        UserMatch.create!(user_id: prospective_user.id, prospective_user_id: user.id, status: 'matched')
        expect {
          post :match, params: { user_id: user.id, prospective_user_id: prospective_user.id }
        }.to change(Notification, :count).by(2)
      end

      it 'handles failed saves' do
        allow_any_instance_of(UserMatch).to receive(:save).and_return(false)
        post :match, params: { user_id: user.id, prospective_user_id: prospective_user.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Failed to match.')
      end
    end
  end

  describe 'POST #skip' do
    context 'when user attempts to skip a prospective user' do
      it 'creates a skipped status for the user match' do
        post :skip, params: { user_id: user.id, prospective_user_id: prospective_user.id }
        expect(response).to be_successful
        user_match = UserMatch.find_by(user_id: user.id, prospective_user_id: prospective_user.id)
        expect(user_match.status).to eq('skipped')
      end

      it 'returns an error if user tries to skip themselves' do
        post :skip, params: { user_id: user.id, prospective_user_id: user.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('You cannot skip yourself.')
      end

      it 'handles failed saves' do
        allow_any_instance_of(UserMatch).to receive(:save).and_return(false)
        post :skip, params: { user_id: user.id, prospective_user_id: prospective_user.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Failed to skip.')
      end
    end
  end

  describe 'POST #block' do
    context 'when user attempts to block a prospective user' do
      it 'creates a blocked status for the user match' do
        post :block, params: { user_id: user.id, prospective_user_id: prospective_user.id }
        expect(response).to be_successful
        user_match = UserMatch.find_by(user_id: user.id, prospective_user_id: prospective_user.id)
        expect(user_match.status).to eq('blocked')
      end

      it 'returns an error if user tries to block themselves' do
        post :block, params: { user_id: user.id, prospective_user_id: user.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('You cannot block yourself.')
      end

      it 'handles failed saves' do
        allow_any_instance_of(UserMatch).to receive(:save).and_return(false)
        post :block, params: { user_id: user.id, prospective_user_id: prospective_user.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Failed to block.')
      end
    end
  end
end
