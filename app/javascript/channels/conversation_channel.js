import consumer from "channels/consumer"

document.addEventListener('turbo:load', () => {
  const messagesContainer = document.getElementById('messages');
  if (messagesContainer) {
    const conversationId = messagesContainer.dataset.conversationId;
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
        messagesContainer.insertAdjacentHTML('beforeend', data.message);
      }
    });
  } else {
    console.log("Messages container not found");
  }
});

