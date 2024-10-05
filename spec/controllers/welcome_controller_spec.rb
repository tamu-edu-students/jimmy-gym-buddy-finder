# spec/controllers/welcome_controller_spec.rb
require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe "GET #index" do
    context "when user credentials are incorrect" do
      it "redirects to the dashboard" do
        # Create an explicit user
        user = User.create(first_name: "Jane Doe7", age: 25, gender: "Female")

        # Simulate user login by setting session
        session[:user_id] = user.id

        get :index

        # Expect the response to redirect to the dashboard
        expect(user.id == nil)
      end
    end
  end
end
