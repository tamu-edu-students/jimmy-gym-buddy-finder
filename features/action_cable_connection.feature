# features/action_cable_connection.feature

Feature: WebSocket connection

  Scenario: Establishing a WebSocket connection
    Given I am a valid user
    When I connect to the Action Cable server
    Then I should receive a confirmation message of successful connection
