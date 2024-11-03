# spec/controllers/users_controller_spec.rb

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user, :complete_profile) }

  before do
    request.env['omniauth.auth'] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: user.email,
        name: user.username
      },
      credentials: {
        token: 'mock_token',
        refresh_token: 'mock_refresh_token',
        expires_at: Time.now + 1.week
      }
    })
    session[:user_id] = user.id
  end

  describe "GET #edit" do
    it "assigns the requested user to @user" do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it "renders the edit template" do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:new_attributes) { { username: "New Name", age: 25, gender: "Female" } }

      it "updates the requested user" do
        patch :update, params: { id: user.id, user: new_attributes }
        user.reload
        expect(user.username).to eq("New Name")
        expect(user.age).to eq(25)
        expect(user.gender).to eq("Female")
      end

      it "redirects to the user profile with a notice on successful update" do
        patch :update, params: { id: user.id, user: new_attributes }
        expect(response).to redirect_to(profile_user_path(user))
        expect(flash[:notice]).to eq("Profile successfully updated and is complete!")
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { { username: "" } }

      it "does not update the user" do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        expect {
          patch :update, params: { id: user.id, user: invalid_attributes }
        }.not_to change { user.reload.username }
      end

      it "re-renders the edit template" do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        patch :update, params: { id: user.id, user: invalid_attributes }
        expect(response).to render_template(:edit)
      end

      it "returns unprocessable_entity status" do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        patch :update, params: { id: user.id, user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with incomplete profile" do
      let(:incomplete_attributes) { { username: "New Name" } }

      before do
        allow_any_instance_of(User).to receive(:update).and_return(true)
        allow_any_instance_of(User).to receive(:valid?).with(:profile_update).and_return(false)
      end

      it "sets a flash alert" do
        patch :update, params: { id: user.id, user: incomplete_attributes }
        expect(flash[:alert]).to eq("Profile is incomplete. Please fill in all required fields.")
      end

      it "re-renders the edit template" do
        patch :update, params: { id: user.id, user: incomplete_attributes }
        expect(response).to render_template(:edit)
      end
    end

    context "with invalid photo size" do
      let(:large_photo) { double('large_photo') }

      before do
        allow(large_photo).to receive(:content_type).and_return('image/jpeg')
        allow(large_photo).to receive(:size).and_return(1.megabyte)
        allow_any_instance_of(User).to receive(:update).and_return(false)
        allow_any_instance_of(User).to receive(:errors).and_return(photo: [ "must be less than 500KB in size." ])
      end

      it "sets a flash alert for photo size" do
        patch :update, params: { id: user.id, user: { photo: large_photo } }
        expect(flash[:alert]).to eq("Photo must be less than 500KB in size.")
      end
    end

    context "with invalid photo format" do
      let(:invalid_photo) { double('invalid_photo') }

      before do
        allow(invalid_photo).to receive(:content_type).and_return('text/plain')
        allow_any_instance_of(User).to receive(:update).and_return(false)
        allow_any_instance_of(User).to receive(:errors).and_return(photo: [ "must be a JPEG, JPG, GIF, or PNG." ])
      end

      it "sets a flash alert for photo format" do
        patch :update, params: { id: user.id, user: { photo: invalid_photo } }
        expect(flash[:alert]).to eq("Photo must be a JPEG, JPG, GIF, or PNG.")
      end
    end
  end
end
