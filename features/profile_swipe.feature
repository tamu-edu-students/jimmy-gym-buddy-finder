# features/profile_swipe.feature

Feature: Profile Swiping

  Background:
    Given I am logged in as a user for profile swipe
    And I have a fitness profile

  Scenario: View profile swipe page
    When I visit the profile swipe page
    Then I should see the profile swipe container
    And I should see the action buttons