require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:user) { FactoryBot.create(:user, :complete_profile) }
  let(:notification) { FactoryBot.create(:notification, user: user) }

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
  end

  context 'when user is logged in' do
    before { session[:user_id] = user.id }

    describe 'GET #index' do
      it 'returns a success response' do
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:ok)
      end

      it 'returns notifications in descending order of creation' do
        notification1 = FactoryBot.create(:notification, user: user, created_at: 1.day.ago)
        notification2 = FactoryBot.create(:notification, user: user, created_at: 2.days.ago)
        get :index, params: { user_id: user.id }
        expect(JSON.parse(response.body).first['id']).to eq(notification1.id)
      end
    end

    describe 'POST #mark_as_read' do
      it 'marks the notification as read' do
        post :mark_as_read, params: { user_id: user.id, id: notification.id }, format: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['read']).to be true
      end

      it 'returns an error for non-existent notification' do
        post :mark_as_read, params: { user_id: user.id, id: 9999 }, format: :json
        expect(response).to have_http_status(:not_found)
      end

      it 'returns unprocessable_entity when update fails' do
        allow_any_instance_of(Notification).to receive(:update).and_return(false)
        post :mark_as_read, params: { user_id: user.id, id: notification.id }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Failed to mark notification as read.')
      end
    end

    describe 'POST #mark_as_unread' do
      it 'marks the notification as unread' do
        notification.update(read: true)
        post :mark_as_unread, params: { user_id: user.id, id: notification.id }, format: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['read']).to be false
      end

      it 'returns an error for non-existent notification' do
        post :mark_as_unread, params: { user_id: user.id, id: 9999 }, format: :json
        expect(response).to have_http_status(:not_found)
      end

      it 'returns unprocessable_entity when update fails' do
        allow_any_instance_of(Notification).to receive(:update).and_return(false)
        post :mark_as_unread, params: { user_id: user.id, id: notification.id }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Failed to mark notification as unread.')
      end
    end
  end

  context 'when user is not logged in' do
    before { session[:user_id] = nil }

    describe 'GET #index' do
      it 'redirects to the welcome page' do
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to('/welcome/index')
      end
    end

    describe 'POST #mark_as_read' do
      it 'redirects to the welcome page' do
        post :mark_as_read, params: { user_id: user.id, id: notification.id }, format: :json
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to('/welcome/index')
      end
    end

    describe 'POST #mark_as_unread' do
      it 'redirects to the welcome page' do
        post :mark_as_unread, params: { user_id: user.id, id: notification.id }, format: :json
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to('/welcome/index')
      end
    end
  end
end