# app/controllers/conversations_controller.rb
class ConversationsController < ApplicationController
  def show
    @other_user = User.find(params[:id])
    @conversation = Conversation.between(current_user.id, @other_user.id).first_or_create!(user1: current_user, user2: @other_user)
    @messages = @conversation.messages.order(created_at: :asc)
    @message = Message.new
  end
end