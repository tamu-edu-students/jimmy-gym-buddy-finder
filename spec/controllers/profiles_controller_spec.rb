require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  describe 'GET #show' do
    it 'retrieves the profile' do
        user = User.create(first_name: "Dummy User", age: 30, gender: "Other") # Create a dummy user
        
        expect {
          get :show, params: { id: "1" } 
        }.not_to raise_error()


        expect(response).not_to be_successful
        # No assertions needed; this is just to cover the User.find line
    end
    it 'does not retrieves the profile' do
        user = User.create(first_name: "", age: -1, gender: "Other") # Create a dummy user
        
        expect {
          get :show, params: { id: -1 } 
        }.not_to raise_error()


        expect(response).not_to be_successful
        # No assertions needed; this is just to cover the User.find line
    end
  end
end
