document.addEventListener("turbo:load", function() {
    const messageInput = document.getElementById("message-input");
    if (messageInput) {
      messageInput.addEventListener("keypress", function(event) {
        if (event.key === "Enter") {
          event.preventDefault();
          sendMessage();
        }
      });
    }
  });
  

  function switchTab(tab) {
    if (tab === 'chat') {
        document.getElementById("chat-tab").classList.add("active");
        document.getElementById("profile-tab").classList.remove("active");
        document.getElementById("chat-tab").style.color = "orange";
        document.getElementById("profile-tab").style.color = "black";
        document.getElementById("chat-area").style.display = "flex";
        document.getElementById("profile-area").style.display = "none";
    } else if (tab === 'profile') {
        document.getElementById("profile-tab").classList.add("active");
        document.getElementById("chat-tab").classList.remove("active");
        document.getElementById("profile-tab").style.color = "orange";
        document.getElementById("chat-tab").style.color = "black";
        document.getElementById("profile-area").style.display = "block";
        document.getElementById("chat-area").style.display = "none";
    }
    document.getElementById("input-area").style.display = "flex";
  }

  function showChat() {
      switchTab('chat');
  }

  function showProfile() {
      switchTab('profile');
  }
  
  function toggleMenu() {
    const dropdown = document.getElementById("dropdown");
    dropdown.style.display = dropdown.style.display === "block" ? "none" : "block";
  }
  
  function sendMessage() {
    const messageInput = document.getElementById("message-input");
    const messageText = messageInput.value.trim();
  
    if (messageText !== "") {
      const chatArea = document.getElementById("chat-area");
  
      // Create a new message element
      const newMessage = document.createElement("div");
      newMessage.className = "message sent";
      newMessage.textContent = messageText;
  
      // Append the new message to the chat area
      chatArea.insertBefore(newMessage, chatArea.firstChild);
  
      // Clear the input field
      messageInput.value = "";
      }
  }
  
  // Close the menu if clicked outside
  window.onclick = function(event) {
    if (!event.target.matches('.menu')) {
      const dropdown = document.getElementById("dropdown");
      if (dropdown.style.display === "block") {
        dropdown.style.display = "none";
      }
    }
  };
  
document.addEventListener('turbo:load', function() {
  const searchInput = document.getElementById('buddy-search');
  const buddyItems = document.querySelectorAll('.buddy-item');

  if (searchInput) {
    searchInput.addEventListener('input', function() {
      const query = searchInput.value.toLowerCase();
      buddyItems.forEach(function(item) {
        const name = item.querySelector('.buddy-name').textContent.toLowerCase();
        if (name.includes(query)) {
          item.style.display = 'flex';
        } else {
          item.style.display = 'none';
        }
      });
    });
  }
});