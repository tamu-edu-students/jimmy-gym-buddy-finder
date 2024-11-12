import consumer from "channels/consumer";

let currentSubscription = null;

function createSubscription(conversationId) {
  if (currentSubscription) {
    consumer.subscriptions.remove(currentSubscription);
    console.log(`Removed existing subscription for conversation ${conversationId}`);
  }

  currentSubscription = consumer.subscriptions.create(
    { channel: "ConversationChannel", conversation_id: conversationId },
    {
      connected() {
        console.log(`Connected to ConversationChannel for conversation ${conversationId}`);
        scrollToBottom(); // Scroll to bottom on connection
      },
      disconnected() {
        console.log(`Disconnected from ConversationChannel for conversation ${conversationId}`);
      },
      received(data) {
        console.log("Received data:", data);
        const messagesContainer = document.getElementById('messages');
        if (messagesContainer) {
          const tempDiv = document.createElement('div');
          tempDiv.innerHTML = data.message;
          const messageDiv = tempDiv.firstElementChild;
          const messageUserId = messageDiv.dataset.userId;
          const currentUserId = document.body.dataset.currentUserId;

          messageDiv.classList.add('text-end');
          if (messageUserId === currentUserId) {
            messageDiv.querySelector('.message-content').classList.add('bg-primary', 'text-white');
          } else {
            messageDiv.querySelector('.message-content').classList.add('bg-light', 'text-dark');
          }

          messagesContainer.appendChild(messageDiv);
          scrollToBottom(); // Scroll to bottom after receiving a new message
        }
      }
    }
  );

  console.log(`Created new subscription for conversation ${conversationId}`);
}

// Function to scroll to the bottom of the messages container
function scrollToBottom() {
  const messagesContainer = document.getElementById('messages');
  if (messagesContainer) {
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  }
}

let isSubmitting = false;

function handleSubmit(event) {
  event.preventDefault();
  if (isSubmitting) return;

  isSubmitting = true;
  const form = event.target;
  const formData = new FormData(form);

  fetch(form.action, {
    method: 'POST',
    body: formData,
    headers: {
      'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").content,
      'Accept': 'application/json'
    }
  }).then(response => {
    if (response.ok) {
      form.reset();
    } else {
      console.error('Error sending message');
    }
  }).catch(error => {
    console.error('Error:', error);
  }).finally(() => {
    isSubmitting = false;
  });
}

document.addEventListener('turbo:load', () => {
  const messagesContainer = document.getElementById('messages');
  if (messagesContainer) {
    const conversationId = messagesContainer.dataset.conversationId;
    createSubscription(conversationId);
    scrollToBottom(); // Scroll to bottom on page load
  }

  const form = document.getElementById('new-message-form');
  if (form) {
    form.removeEventListener('submit', handleSubmit);
    form.addEventListener('submit', handleSubmit);
  }
});

document.addEventListener('turbo:before-cache', () => {
  if (currentSubscription) {
    consumer.subscriptions.remove(currentSubscription);
    currentSubscription = null;
    console.log("Removed subscription before caching");
  }
});