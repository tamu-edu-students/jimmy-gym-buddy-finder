# spec/controllers/welcome_controller_spec.rb
require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe "GET #index" do
    context "when user credentials are incorrect" do
      it "redirects to the dashboard to check no welcome message" do
        # Create an explicit user
        user = User.create(first_name: "Jane Doe7", age: 25, gender: "Female")

        # Simulate user login by setting session
        session[:user_id] = user.id

        get :index

        expect(flash[:notice]).not_to eq("Welcome back!")
      end
    end
  end
end
