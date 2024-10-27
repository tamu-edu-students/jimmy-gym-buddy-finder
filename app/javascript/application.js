// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "popper";
import "bootstrap";

'use strict';

document.addEventListener("DOMContentLoaded", function () {
  let currentCardIndex = 0;
  const cards = document.querySelectorAll(".profile-card");

  // Show the first card initially
  if (cards.length > 0) {
    cards[0].style.display = "block";
  }

  // Function to handle Block, Skip, Like actions
  window.handleAction = function (action) {
    if (cards.length === 0) return;

    // Hide current card
    cards[currentCardIndex].style.display = "none";

    // Move to the next card (loop back if at the end)
    currentCardIndex = (currentCardIndex + 1) % cards.length;

    // Show the next card
    cards[currentCardIndex].style.display = "block";
  };

  // Function to filter profiles by search input
  window.filterProfiles = function () {
    const searchTerm = document.getElementById("search").value.toLowerCase();
    cards.forEach((card) => {
      const profileText = card.innerText.toLowerCase();
      card.style.display = profileText.includes(searchTerm) ? "block" : "none";
    });
  };
});

// document.addEventListener('turbo:load', function () {
//   var tinderContainer = document.querySelector('.tinder');
//   var allCards = document.querySelectorAll('.tinder--card');
//   var nope = document.getElementById('nope');
//   var love = document.getElementById('love');

//   function initCards() {
//     var newCards = document.querySelectorAll('.tinder--card:not(.removed)');

//     newCards.forEach(function (card, index) {
//       card.style.zIndex = allCards.length - index;
//       card.style.transform = 'scale(' + (20 - index) / 20 + ') translateY(-' + 30 * index + 'px)';
//       card.style.opacity = (10 - index) / 10;
//     });

//     tinderContainer.classList.add('loaded');
//   }

//   function setupHammer() {
//     allCards.forEach(function (el) {
//       var hammertime = new Hammer(el);

//       hammertime.on('pan', function (event) {
//         el.classList.add('moving');
//         if (event.deltaX === 0) return;
//         if (event.center.x === 0 && event.center.y === 0) return;

//         tinderContainer.classList.toggle('tinder_love', event.deltaX > 0);
//         tinderContainer.classList.toggle('tinder_nope', event.deltaX < 0);

//         var xMulti = event.deltaX * 0.03;
//         var yMulti = event.deltaY / 80;
//         var rotate = xMulti * yMulti;

//         event.target.style.transform = 'translate(' + event.deltaX + 'px, ' + event.deltaY + 'px) rotate(' + rotate + 'deg)';
//       });

//       hammertime.on('panend', function (event) {
//         el.classList.remove('moving');
//         tinderContainer.classList.remove('tinder_love');
//         tinderContainer.classList.remove('tinder_nope');

//         var moveOutWidth = document.body.clientWidth;
//         var keep = Math.abs(event.deltaX) < 80 || Math.abs(event.velocityX) < 0.5;

//         event.target.classList.toggle('removed', !keep);

//         if (keep) {
//           event.target.style.transform = '';
//         } else {
//           var endX = Math.max(Math.abs(event.velocityX) * moveOutWidth, moveOutWidth);
//           var toX = event.deltaX > 0 ? endX : -endX;
//           var endY = Math.abs(event.velocityY) * moveOutWidth;
//           var toY = event.deltaY > 0 ? endY : -endY;
//           var xMulti = event.deltaX * 0.03;
//           var yMulti = event.deltaY / 80;
//           var rotate = xMulti * yMulti;

//           event.target.style.transform = 'translate(' + toX + 'px, ' + (toY + event.deltaY) + 'px) rotate(' + rotate + 'deg)';
//         }

//         // Re-initialize cards after panning
//         initCards();
//       });
//     });
//   }

//   function createButtonListener(love) {
//     return function (event) {
//       var cards = document.querySelectorAll('.tinder--card:not(.removed)');
//       var moveOutWidth = document.body.clientWidth * 1.5;

//       if (!cards.length) return false;

//       var card = cards[0];
//       card.classList.add('removed');

//       if (love) {
//         card.style.transform = 'translate(' + moveOutWidth + 'px, -100px) rotate(-30deg)';
//       } else {
//         card.style.transform = 'translate(-' + moveOutWidth + 'px, -100px) rotate(30deg)';
//       }

//       // Reset state after button click
//       initCards();
//       event.preventDefault();
//     };
//   }

//   // Clear event listeners before setting up to avoid duplicates
//   nope.removeEventListener('click', createButtonListener(false));
//   love.removeEventListener('click', createButtonListener(true));

//   var nopeListener = createButtonListener(false);
//   var loveListener = createButtonListener(true);

//   nope.addEventListener('click', nopeListener);
//   love.addEventListener('click', loveListener);

//   // Ensure the cards are initialized correctly on page load
//   initCards();
//   setupHammer(); // Set up Hammer.js event listeners
// });
