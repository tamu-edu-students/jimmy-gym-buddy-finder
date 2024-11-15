require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do
  let(:user) { FactoryBot.create(:user, :complete_profile) }
  let(:other_user) { FactoryBot.create(:user, :complete_profile) }

  before do
    # Simulate user login
    session[:user_id] = user.id
    allow(controller).to receive(:current_user).and_return(user)

    # Create mutual "matched" relationship if needed by app logic
    UserMatch.create!(user_id: user.id, prospective_user_id: other_user.id, status: "matched")
    UserMatch.create!(user_id: other_user.id, prospective_user_id: user.id, status: "matched")
  end

  describe "GET #show" do
    context "when viewing a conversation with a matched user" do
      before do
        get :show, params: { user_id: user.id, id: other_user.id }
      end

      it "assigns the current user and other user" do
        expect(assigns(:current_user)).to eq(user)
        expect(assigns(:other_user)).to eq(other_user)
      end

      it "finds or creates a conversation between the users" do
        conversation = Conversation.between(user.id, other_user.id).first
        expect(assigns(:conversation)).to eq(conversation)
      end

      it "assigns messages in ascending order of creation to @messages" do
        conversation = assigns(:conversation)
        message1 = FactoryBot.create(:message, conversation: conversation, user: user, content: "Hello!")
        message2 = FactoryBot.create(:message, conversation: conversation, user: other_user, content: "Hi!")

        get :show, params: { user_id: user.id, id: other_user.id }
        expect(assigns(:messages)).to eq([ message1, message2 ])
      end

      it "initializes a new message for the form" do
        expect(assigns(:message)).to be_a_new(Message)
      end
    end
  end
end
