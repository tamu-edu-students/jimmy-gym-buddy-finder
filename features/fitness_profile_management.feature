Feature: User Fitness Profile Creation and Management
  As a user
  I want to create a fitness profile that includes my fitness-related information and preferences
  So that I can connect with workout partners and find activities that suit my interests and availability.
  
  Scenario: Create a Fitness Profile for the first time
    Given I am logged in
    When I am on my dashboard page
    Then I should be able to create a fitness profile
    When I click the create fitness profile icon
    Then I should be able to modify my fitness goals
    Then I should be able to modify my workout types
    Then I should be able to select gender to match
    Then I should be able to select age range to match
    Then I should be able to save the fitness profile
    Then I should see the confirm message when the fitness profile is created successfully

  Scenario: Update fitness profile
    Given I am logged in
    Given I have created my fitness profile
    When I am on my fitness page
    Then I should see my fitness profile
    Then I should able to edit my fitness profile
    Then I should be able to change my fitness goals
    Then I should be able to change my workout types
    Then I should be able to change gender to match
    Then I should be able to change age range to match
    Then I should be able to save these updates
    Then I should see the confirm message when the fitness profile is updated successfully