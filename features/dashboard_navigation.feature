Feature: Dashboard Navigation
  As a user
  So I can understand the available features and manage my profile
  I want to see feature introductions and navigate to the user profile management page

  Background:
  Given the database is reset
  And a user exists with the following details:
    | field      | value               |
    | first_name | TestUser            |
    | last_name  | TestLastName        |
    | age        | 25                  |
    | gender     | female              |
    | email      | test@gmail.com      |
    | password   | dummy               |

  Scenario: View feature introductions and navigate to User Profile Management
    Given I am on the dashboard page
    When I enter the dashboard for the first time
    Then I should see introductions for each feature displayed on the screen
    