Feature: User Authentication
  As a user
  I want to authenticate using Google OAuth
  So that I can access and use the platform

  Scenario: Successfully logging in via Google OAuth
    Given I am not logged in
    When I visit the login page
    And I click the "Login with Google" button
    And I am authenticated successfully
    Then I should be redirected to my dashboard
    And I should see "You are logged in and your profile is complete."

  Scenario: Failed login via Google OAuth
    Given I am not logged in
    When I visit the login page
    And I click the "Login with Google" button
    And I deny access
    Then I should be redirected to the failure path
    And I should see "You have denied access. Please try again or use a different account."

  Scenario: Logging out
    Given I am logged in
    When I click the "Logout" button
    Then I should be redirected to the welcome page
    And I should see "You are logged out."

  Scenario: Incomplete profile after login
    Given I am not logged in
    When I visit the login page
    And I click the "Login with Google" button
    And I am authenticated but my profile is incomplete
    Then I should be redirected to the edit profile page
    And I should see "Please complete your profile information."

  Scenario: Failed login due to invalid credentials
    Given I am not logged in
    When I visit the login page
    And I click the "Login with Google" button
    And the login fails
    Then I should be redirected to the welcome page
    And I should see "Login failed. Please try again."