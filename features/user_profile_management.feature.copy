Feature: User Profile Management
  As a user
  So I can update my personal information
  I want to be able to change my photo, modify my name, modify my gender, and set my age on the profile management page

  Background:
  Given the database is reset
  And a user exists with the following details:
    | field      | value               |
    | first_name | TestUser            |
    | last_name  | TestLastName   |
    | age        | 25                  |
    | gender     | female              |

  Scenario: Edit user profile details
    Given I am on the User Profile Management page
    When I want to update my profile
    Then I should be able to upload and change my profile photo
    Then I should be able to modify my name
    Then I should be able to modify my gender
    Then I should be able to set or update my age using a date picker
    Then I should be able to save these changes
    Then I should see a confirmation message when the updates are successfully saved