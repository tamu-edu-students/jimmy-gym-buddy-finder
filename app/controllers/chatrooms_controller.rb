class ChatroomsController < ApplicationController
  def show
    @buddy_name = params[:buddy_name].capitalize
    # NEED link with backend
    @messages = [
      { sender: "You", content: "Hello!" },
      { sender: @buddy_name, content: "Hi there!" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" },
      { sender: "You", content: "test" }
    ]
  end
end
