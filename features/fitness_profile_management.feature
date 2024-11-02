@javascript
Feature: User Fitness Profile Creation and Management
  As a user
  I want to create a fitness profile that includes my fitness-related information and preferences
  So that I can connect with workout partners and find activities that suit my interests and availability.

  Scenario: Create a Fitness Profile for the first time
    Given I am logged in
    When I am on my dashboard page
    Then I should be able to create a fitness profile
    When I click the create fitness profile icon
    Then I should be able to select gender to match
    Then I should be able to select age range to match
    Then I should be able to select gym locations to match
    When I select "Soccer" as the preferred activity
    And I select "Amateur" as the experience level
    And I add the activity to my list
    Then I should see "Soccer - Amateur" in my activity list
    When I select "Monday" as the workout day
    Then I should see "Monday" in my workout schedule list
    When I select "Cardio" as the preferred workout type
    And I add the workout type to my list
    Then I should see "Cardio" in my workout type list
    Then I should be able to save the fitness profile
    Then I should see the confirm message when the fitness profile is created successfully

  Scenario: Editing the Fitness Profile
    Given I am logged in
    When I am on my dashboard page
    And I have created my fitness profile
    When I press the "Edit Profile" button
    And I update the gender preferences to "Female" only
    When I submit the form
    Then I should see the message "Fitness profile updated successfully"
    And I should see "Female" as the selected gender preference

  Scenario: Creating the Fitness Profile with missing values 
    Given I am logged in
    When I am on my dashboard page
    And I click the create fitness profile
    And I select age range from "28" to "18"
    When I submit the form without selecting other columns
    Then I should see "Please select at least one gender preference" in the gender feedback
    Then I should see "Maximum age must be greater than minimum age" in the age feedback