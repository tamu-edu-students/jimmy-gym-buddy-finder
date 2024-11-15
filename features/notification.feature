Feature: Match Notification
  As a user
  I want to receive a notification when a mutual match occurs
  So that I am informed when another user has also matched with me

  Scenario: Notification creation after a mutual match
    Given I am logged in as a user
    And there is a prospective user
    And the prospective user has already matched with me
    When I match with the prospective user
    Then I should see a success message
    And a notification should be created for the user who matched
  
  Scenario: Mark a notification as read
    Given I am logged in as a user
    And I have an unread notification
    When I mark the notification as read
    Then the notification should be marked as read
    And I should see a JSON response confirming the change

  Scenario: Mark a notification as unread
    Given I am logged in as a user
    And I have a read notification
    When I mark the notification as unread
    Then the notification should be marked as unread