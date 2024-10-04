# spec/controllers/welcome_controller_spec.rb

require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET #index' do
    context 'when the user is logged in' do
      let(:user) { create(:user) }  # Use FactoryBot to create a user, or replace with your user creation logic

      before do
        # Simulate user being logged in
        allow(controller).to receive(:logged_in?).and_return(true)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'redirects to the user dashboard with a welcome back notice' do
        get :index

        expect(response).to redirect_to(dashboard_user_path(user))
        expect(flash[:notice]).to eq('Welcome back!')
      end
    end

    context 'when the user is not logged in' do
      before do
        # Simulate user not being logged in
        allow(controller).to receive(:logged_in?).and_return(false)
      end

      it 'does not redirect and renders the index template' do
        get :index

        expect(response).to render_template(:index)
        expect(flash[:notice]).to be_nil
      end
    end
  end
end
