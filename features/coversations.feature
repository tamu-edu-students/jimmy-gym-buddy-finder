Feature: Conversations and Messages
  As a user
  I want to have a conversation with a matched user
  So that I can send and receive messages in real-time

  Background:
    Given I am logged in as a user
    And I have a matched user
    And I start a conversation with the matched user
  
   @javascript
  
  @javascript
  Scenario: Sending a message in a conversation
    Given I am on the conversation page
    When I create a new message with content "Hello, Gym Buddy!"
    Then the message should be saved to the database
    And I should see the message in the conversation

