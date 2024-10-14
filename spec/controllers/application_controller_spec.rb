# spec/controllers/application_controller_spec.rb

require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  controller do
    before_action :require_login

    def index
      render plain: 'Logged in successfully.'
    end
  end

  describe 'GET #index' do
    context 'when the user is not logged in' do
      before do
        # Simulate user not being logged in
        allow(controller).to receive(:logged_in?).and_return(false)
        get :index  # Trigger the index action to invoke require_login
      end

      it 'redirects to the welcome page' do
        expect(response).to redirect_to(welcome_path)  # Change to welcome_path instead of root_path
      end

      it 'sets the flash alert message' do
        expect(flash[:alert]).to eq('You must be logged in to access this section.')
      end
    end
  end
end
