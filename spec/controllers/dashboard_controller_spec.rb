# spec/controllers/dashboard_controller_spec.rb
require 'rails_helper'  # Use 'rails_helper' instead of 'spec_helper'

RSpec.describe DashboardController, type: :controller do
  let!(:user) { create(:user) } # Assuming you have a User factory set up

  describe 'GET #show' do
    context 'when the user exists' do
      it 'assigns the requested user to @user' do
        get :show, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end

      it 'renders the show template' do
        get :show, params: { id: user.id }
        expect(response).to render_template(:show)
      end
    end

    context 'when the user does not exist' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          get :show, params: { id: -1 } # Using an ID that doesn't exist
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
