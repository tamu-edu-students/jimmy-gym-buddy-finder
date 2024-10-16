Feature: User Profile Management
  As a user
  So I can update my personal information
  I want to be able to change my photo, modify my name, modify my gender, and set my age on the profile management page

  Scenario: Edit user profile details
    Given I am logged in
    When I am on my dashboard page
    Then I should be able to access my user profile
    Then I should see my user profile
    Then I should be able to edit my user profile
    Then I should be able to upload and change my profile photo
    Then I should be able to change my user name
    Then I should be able to set or update my age using a date picker
    Then I should be able to modify my gender
    Then I should be able to modify my school
    Then I should be able to modify my major
    Then I should be able to modify about me
    Then I should be able to save these changes
    Then I should see a confirmation message when the updates are successfully saved

  Scenario: Edit user profile with invalid inputs
    Given I am logged in
    When I am on my dashboard page
    Then I should be able to access my user profile
    Then I should be able to edit my user profile
    When I try to upload photo with invalid format and save
    Then I should see error message of invalid photo format
    When I try to upload photo with invalid size and save
    Then I should see error message of invalid photo size

  Scenario: Edit user profile with incomplete inputs
    Given I am logged in
    When I am on my dashboard page
    Then I should be able to access my user profile
    Then I should be able to edit my user profile
    When I try to leave my username blank and save
    Then I should see error message of incomplete user profile
