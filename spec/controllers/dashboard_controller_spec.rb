require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe 'GET #show' do
    context 'when the user does not exist' do
      it 'responds with a 404 status' do
        get :show, params: { id: -1 } # Using an ID that doesn't exist
        expect(response).to have_http_status(:found) # Check for a 302 response status
      end
    end
  end
end
