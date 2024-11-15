class MessagesController < ApplicationController
  def create
    Rails.logger.debug "MessagesController#create called with params: #{params.inspect}"
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.new(message_params)
    @message.user = current_user

    if @message.save
      html = ApplicationController.render(
        partial: "messages/message",
        locals: { message: @message, current_user: current_user }
      )
      ActionCable.server.broadcast(
        "conversation_channel_#{@conversation.id}",
        { message: html }
      )
      render json: { status: "success" }, status: :created
    else
      render json: { error: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
