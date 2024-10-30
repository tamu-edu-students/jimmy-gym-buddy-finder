require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let!(:notifications) { FactoryBot.create_list(:notification, 3, user: user) }

  before do
    # Setup OmniAuth for testing
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: user.email,
        username: user.username
      },
      credentials: {
        token: 'mock_token',
        refresh_token: 'mock_refresh_token',
        expires_at: Time.now + 1.week
      }
    })

    # Simulate user sign in
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'returns a list of notifications in descending order' do
      get :index, params: { user_id: user.id }  # Include user_id in params
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
      expect(JSON.parse(response.body).first['id']).to eq(notifications.last.id)
    end
  end

  describe 'POST #mark_as_read' do
    let(:notification) { FactoryBot.create(:notification, user: user) }

    it 'marks the notification as read' do
      post :mark_as_read, params: { user_id: user.id, id: notification.id }
      expect(response).to have_http_status(:ok)
      expect(notification.reload.read).to be true
      expect(JSON.parse(response.body)['message']).to eq('Notification marked as read.')
    end
  end
end
