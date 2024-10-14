Feature: User Login

  Scenario: User visits the login page
    Given I am on the login page
    Then I should see the main heading
    And I should see the subtitle
    And I should see the login image
    And I should see a button to log in
