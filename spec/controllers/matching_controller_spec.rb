require 'rails_helper'

RSpec.describe MatchingController, type: :controller do
  let(:user) { FactoryBot.create(:user, :complete_profile) }
  let(:prospective_user) { FactoryBot.create(:user, :complete_profile) }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
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
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    session[:user_id] = user.id
  end

  describe 'GET #profileswipe' do
    it 'assigns @user_id' do
      get :profileswipe, params: { user_id: user.id }
      expect(assigns(:user_id)).to eq(user.id.to_s)
    end

    it 'calls prospective_users method on UserMatchesController' do
      user_matches_controller = instance_double(UserMatchesController)
      allow(UserMatchesController).to receive(:new).and_return(user_matches_controller)
      allow(user_matches_controller).to receive(:request=)
      allow(user_matches_controller).to receive(:response=)
      expect(user_matches_controller).to receive(:prospective_users)
      get :profileswipe, params: { user_id: user.id }
    end

    it 'assigns @prospective_users' do
      allow_any_instance_of(UserMatchesController).to receive(:prospective_users).and_return([prospective_user])
      get :profileswipe, params: { user_id: user.id }
      expect(assigns(:prospective_users)).to eq([prospective_user])
    end

    it 'renders the profileswipe template' do
      get :profileswipe, params: { user_id: user.id }
      expect(response).to render_template('profileswipe')
    end
  end

  describe 'authentication' do
    it 'sets user_id in session after successful authentication' do
      get :profileswipe, params: { user_id: user.id }
      expect(session[:user_id]).to eq(user.id)
    end

    it 'has a valid OmniAuth hash' do
      expect(request.env['omniauth.auth']).to be_a(OmniAuth::AuthHash)
      expect(request.env['omniauth.auth'].provider).to eq('google_oauth2')
      expect(request.env['omniauth.auth'].uid).to eq('123456789')
    end
  end
end