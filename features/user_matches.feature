Feature: User Matches
  As a user
  I want to manage my potential matches
  So that I can find suitable workout partners

  Background:
    Given I am logged in as a user

  Scenario: View prospective users
    When I request to view prospective users
    Then I should see a list of filtered prospective users

  Scenario: Match with a prospective user
    Given there is a prospective user
    When I match with the prospective user
    Then I should see a success message
    And a match should be created in the database

  Scenario: Skip a prospective user
    Given there is a prospective user
    When I skip the prospective user
    Then I should see a success message
    And a skip record should be created in the database

  Scenario: Block a prospective user
    Given there is a prospective user
    When I block the prospective user
    Then I should see a success message
    And a block record should be created in the database

  Scenario: Attempt to match with oneself
    When I try to match with myself
    Then I should see an error message

  Scenario: Attempt to skip oneself
    When I try to skip myself
    Then I should see an error message

  Scenario: Attempt to block oneself
    When I try to block myself
    Then I should see an error message

  Scenario: Mutual match creates notifications
    Given there is a prospective user who has matched with me
    When I match with the prospective user
    Then I should see a success message
    And notifications should be created for both users

  Scenario: Failed match
    Given there is a prospective user
    And the match will fail to save
    When I match with the prospective user
    Then I should see a failure message

  Scenario: Failed skip
    Given there is a prospective user
    And the skip will fail to save
    When I skip the prospective user
    Then I should see a failure message

  Scenario: Failed block
    Given there is a prospective user
    And the block will fail to save
    When I block the prospective user
    Then I should see a failure message

  Scenario: View filtered prospective users
    Given there are multiple prospective users with various profiles
    When I request to view prospective users
    Then I should see a list of filtered prospective users
    And the list should only include users matching my preferences  