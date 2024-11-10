
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "popper";
import "bootstrap";

'use strict';

document.addEventListener("ajax:success", (event) => {
    const [data] = event.detail;
    const notificationId = data.id;
    const buttonContainer = document.querySelector(`#mark-button-${notificationId}`);
  
    if (data.read) {
      buttonContainer.innerHTML = `
        <form action="/users/${user_id}/notifications/${notificationId}/mark_as_unread" method="post" data-remote="true">
          <input type="submit" value="Mark as Unread" class="btn btn-sm btn-outline-secondary">
        </form>`;
    } else {
      buttonContainer.innerHTML = `
        <form action="/users/${user_id}/notifications/${notificationId}/mark_as_read" method="post" data-remote="true">
          <input type="submit" value="Mark as Read" class="btn btn-sm btn-outline-secondary">
        </form>`;
    }
  });
import "channels"
