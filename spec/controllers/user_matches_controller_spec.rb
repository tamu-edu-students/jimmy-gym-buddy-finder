require 'rails_helper'

RSpec.describe UserMatchesController, type: :controller do
    let(:user) { FactoryBot.create(:user, :complete_profile) }
    let(:prospective_user) { FactoryBot.create(:user, fitness_profile: FactoryBot.create(:fitness_profile)) }
    let(:fitness_profile) { FactoryBot.create(:fitness_profile, user: user) } # Now uses the new factory

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
        user.update(fitness_profile: fitness_profile) # Link the fitness_profile to user
    end

  describe 'GET #prospective_users' do
    context 'when prospective users are available' do
      it 'renders sorted prospective users as JSON' do
        user_match = UserMatch.create!(user_id: user.id, prospective_user_id: prospective_user.id, status: 'new')
        get :prospective_users, params: { id: user.id }
        expect(response).to be_successful
        expect(JSON.parse(response.body).first['id']).to eq(prospective_user.id)
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
    end
  end
end
