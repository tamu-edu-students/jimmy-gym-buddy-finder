Feature: User Authentication
  As a user
  I want to authenticate using Google OAuth
  So that I can access and use the platform

  Scenario: Redirect to Google Authentication.
    Given I am not logged in
    When I am on the welcome page
    Then I should see the button "Login with Google"

  Scenario: First time login
    Given I am not logged in
    When I am on the welcome page
    And I click the "Login with Google" button
    Then I should see the profile message "Please complete your profile information"

  Scenario: Successfully login via Google OAuth
    Given I am a well-configured user and not log in
    When I am on the welcome page
    And I click the "Login with Google" button
    Then I should be redirected to my dashboard
  
  Scenario: Non-configured user successfully login via Google OAuth
    Given I am a non-configured user and not log in
    When I am on the welcome page
    And I click the "Login with Google" button
    Then I should be redirected to edit profile page
    Then I should see the profile message "Please complete your profile information"

  @omniauth_fail
  Scenario: Failed login via Google OAuth
    Given I am not logged in
    When I am on the welcome page
    And I click the "Login with Google" button
    Then I should be redirected to the welcome page
    And I should see the profile message "Authentication failed."

  Scenario: Logging out
    Given I am logged in
    When I am on my dashboard page
    And I click "Log Out"
    Then I should be redirected to the welcome page
    And I should see the profile message "You are logged out."

  Scenario: Logging in and return to welcome page
    Given I am logged in
    When I am on the welcome page
    Then I should be redirected to my dashboard
    And I should see the profile message "Welcome back!"
  
  Scenario: Non-configured user redirect to other pages
    Given I am logged in as an non-configured user
    When I am on the welcome page
    Then I should be redirected to edit profile page
    And I should see the profile message "Please complete your profile information before accessing other sections."

  Scenario: Accessing the dashboard without logging in
    Given I am a well-configured user and not log in
    When I am on my dashboard page
    Then I should be redirected to the welcome page
    And I should see the profile message "You must be logged in to access this section."