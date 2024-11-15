require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { FactoryBot.create(:user, :complete_profile) }
  let(:matched_user) { FactoryBot.create(:user, :complete_profile) }
  let(:conversation) { Conversation.between(user.id, matched_user.id).first_or_create!(user1: user, user2: matched_user) }

  before do
    # Simulate user login
    session[:user_id] = user.id
    allow(controller).to receive(:current_user).and_return(user)

    # Create mutual "matched" relationship
    UserMatch.create!(user_id: user.id, prospective_user_id: matched_user.id, status: "matched")
    UserMatch.create!(user_id: matched_user.id, prospective_user_id: user.id, status: "matched")
  end

  describe "POST #create" do
    let(:valid_message_params) { { conversation_id: conversation.id, message: { content: "Hello, Gym Buddy!" } } }
    let(:invalid_message_params) { { conversation_id: conversation.id, message: { content: "" } } }

    before do
      request.env["HTTP_ACCEPT"] = "application/json"
    end

    context "with valid params" do
      it "creates a new message in the conversation" do
        expect {
          post :create, params: valid_message_params, format: :json
        }.to change(conversation.messages, :count).by(1)
      end

      it "returns a successful JSON response" do
        post :create, params: valid_message_params, format: :json
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq("status" => "success")
      end
    end

    context "with invalid params" do
      it "does not create a new message" do
        expect {
          post :create, params: invalid_message_params, format: :json
        }.not_to change(conversation.messages, :count)
      end

      it "returns an error JSON response" do
        post :create, params: invalid_message_params, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("error")
      end
    end
  end
end
