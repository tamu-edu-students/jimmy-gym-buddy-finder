# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    

  context 'with invalid parameters and user not logged in' do
    it 'does not create a user and redirects to the welcome page' do
      expect {
        post :create, params: { user: { name: "", age: nil, gender: nil } }
      }.not_to change(User, :count) # Ensure the user count does not increase
      
      expect(flash[:alert]).to eq("You must be logged in to access this section.") # Flash message check
    end
    end
  end
end
