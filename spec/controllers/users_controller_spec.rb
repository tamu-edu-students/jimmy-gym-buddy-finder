require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user, :complete_profile) }

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: user.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      let(:valid_attributes) { { username: "new_username", age: 25 } }

      it "updates the user and redirects to profile" do
        patch :update, params: { id: user.id, user: valid_attributes }
        expect(assigns(:user).username).to eq("new_username")
        expect(response).to redirect_to(profile_user_path(user))
        expect(flash[:notice]).to eq("Profile successfully updated and is complete!")
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { { username: "", age: 25 } }

      it "renders the edit template with errors" do
        patch :update, params: { id: user.id, user: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq("There were errors while updating the profile. Please check the fields and try again.")
      end
    end
  end
end
