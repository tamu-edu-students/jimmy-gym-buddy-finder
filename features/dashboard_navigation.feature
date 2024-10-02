Feature: Dashboard Navigation
  As a user
  So I can understand the available features and manage my profile
  I want to see feature introductions and navigate to the user profile management page

  Scenario: View feature introductions and navigate to User Profile Management
    Given I am on the dashboard page
    When I enter the dashboard for the first time
    Then I should see introductions for each feature displayed on the screen
    When I click the "Profile" icon
    Then I should be navigated to the User Profile Management page