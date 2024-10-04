# features/require_login.feature
Feature: Login requirement
  As a visitor
  I want to be redirected to the welcome page when I’m not logged in
  So that I cannot access protected pages without authentication

  Background:
    Given I am on the protected page

  Scenario: Accessing a protected page when not logged in
    Given I am not logged in
    When I try to visit the protected page
    Then I should be redirected to the welcome page
    And I should see "You must be logged in to access this section."

  Scenario: Accessing a protected page when logged in
    Given I am logged in as a user
    When I try to visit the protected page
    Then I should see the protected page content
    And I should not see "You must be logged in to access this section."
