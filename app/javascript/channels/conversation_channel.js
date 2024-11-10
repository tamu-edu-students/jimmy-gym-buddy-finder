import consumer from "channels/consumer";

document.addEventListener('turbo:load', () => {
  const messagesContainer = document.getElementById('messages');

  if (messagesContainer) {
    const conversationId = messagesContainer.dataset.conversationId;
    const currentUserId = document.body.dataset.currentUserId; // Ensure currentUserId is available

    console.log(`Creating subscription for conversation ${conversationId}`);

    consumer.subscriptions.create({ channel: "ConversationChannel", conversation_id: conversationId }, {
      connected() {
        console.log(`Connected to ConversationChannel for conversation ${conversationId}`);
      },

      disconnected() {
        console.log(`Disconnected from ConversationChannel for conversation ${conversationId}`);
      },

      received(data) {
        console.log("Received data:", data);

        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = data.message;
        const messageDiv = tempDiv.firstElementChild;

        const messageUserId = messageDiv.dataset.userId; // Get user ID of the message sender

        // Apply consistent right alignment for all messages
        messageDiv.classList.add('text-end');

        // Check if the message was sent by the current user or another user
        if (messageUserId === currentUserId) {
          // Sent by current user -> Blue background, white text
          messageDiv.querySelector('.message-content').classList.add('bg-primary', 'text-white');
        } else {
          // Received from another user -> Light background, dark text
          messageDiv.querySelector('.message-content').classList.add('bg-light', 'text-dark');
        }

        // Append the new message to the container
        messagesContainer.appendChild(messageDiv);

        // Scroll to the bottom of the chat container
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
      }
    });
  } else {
    console.log("Messages container not found");
  }
});
