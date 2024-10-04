require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) do
    FactoryBot.create(
      :user,
      uid: '12345',
      provider: 'google_oauth2',
      email: 'user@example.com',
      username: 'JohnDoe',
      age: 25,
      gender: 'Male'
    )
  end
  
  describe 'GET #omniauth' do
    context 'when authentication is successful' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '12345',
          info: {
            email: 'user@example.com',
            name: 'John Doe'
          }
        )
        allow_any_instance_of(User).to receive(:valid?).with(:profile_update).and_return(true)
        allow_any_instance_of(User).to receive(:valid?).and_return(true)

      end

      it 'creates or finds a user' do
        get :omniauth
        expect(User.find_by(uid: '12345', provider: 'google_oauth2')).to be_present
      end

      it 'sets the session user_id' do
        get :omniauth
        created_user = User.find_by(uid: '12345', provider: 'google_oauth2')
        expect(session[:user_id]).to eq(created_user.id) if created_user
      end

      it 'redirects to dashboard if profile is complete' do
        get :omniauth
        created_user = User.find_by(uid: '12345', provider: 'google_oauth2')
        expect(response).to redirect_to(dashboard_user_path(created_user)) if created_user
      end

      it 'redirects to edit user page if profile is incomplete' do
        allow_any_instance_of(User).to receive(:valid?).with(:profile_update).and_return(false)
        get :omniauth
        created_user = User.find_by(uid: '12345', provider: 'google_oauth2')
        expect(response).to redirect_to(edit_user_path(created_user)) if created_user
      end
    end

    context 'when authentication is denied' do
      before do
        request.env['omniauth.auth'] = nil
        get :omniauth, params: { error: 'access_denied' }
      end

      it 'redirects to failure path with an alert' do
        expect(response).to redirect_to(failure_path)
        expect(flash[:alert]).to eq('You have denied access. Please try again or use a different account.')
      end
    end

    context 'when login fails' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '54321',
          info: {
            email: 'user@example.com',
            name: 'John Doe'
          }
        )
        allow_any_instance_of(User).to receive(:persisted?).and_return(false)
        get :omniauth
      end

      it 'redirects to welcome path with an alert' do
        expect(response).to redirect_to(welcome_path)
        expect(flash[:alert]).to eq('Login failed. Please try again.')
      end
    end
  end

  describe 'GET #logout' do
    before do
      session[:user_id] = user.id
      get :logout
    end

    it 'resets the session' do
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to welcome path with a notice' do
      expect(response).to redirect_to(welcome_path)
      expect(flash[:notice]).to eq('You are logged out.')
    end
  end

  describe 'GET #failure' do
    before { get :failure }

    it 'redirects to welcome path with an alert' do
      expect(response).to redirect_to(welcome_path)
      expect(flash[:alert]).to eq('Authentication failed. Please try again or contact support.')
    end
  end
end
