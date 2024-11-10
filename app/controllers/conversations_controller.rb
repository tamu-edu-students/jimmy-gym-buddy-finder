# app/controllers/conversations_controller.rb
class ConversationsController < ApplicationController
  def show
    @current_user = User.find(params[:user_id])
    @other_user = User.find(params[:id])
    @conversation = Conversation.between(@current_user.id, @other_user.id).first_or_create!(user1: @current_user, user2: @other_user)
    @messages = @conversation.messages.order(created_at: :asc)
    @message = Message.new
  end
end