require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  let(:user) { create(:user) }

  before do
    # Simulate user login by setting session
    session[:user_id] = user.id
  end

  describe "GET #index" do
    context "when user is logged in" do
      it "redirects to the dashboard" do
        get :index
        expect(response).to redirect_to(dashboard_user_path(user))
      end
    end

    context "when user is not logged in" do
      before do
        session[:user_id] = nil
      end

      it "renders the index page" do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end
