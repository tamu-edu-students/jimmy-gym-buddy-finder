
# features/step_definitions/user_matches_steps.rb

require 'rack/test'
require 'rspec/mocks/standalone'
World(RSpec::Mocks::ExampleMethods)
World(Rack::Test::Methods)

Given("I am logged in as a user") do
  @user = FactoryBot.create(:user, :complete_profile)
  page.set_rack_session(user_id: @user.id)
end

When("I request to view prospective users") do
  visit "/users/#{@user.id}/prospective_users.json"
  @response_body = JSON.parse(page.body)
end

Then("I should see a list of filtered prospective users") do
  expect(page.status_code).to eq(200)
  expect(@response_body).to be_an(Array)
end

Given("there is a prospective user") do
  @prospective_user = FactoryBot.create(:user, :complete_profile)
end

When("I match with the prospective user") do
  @current_action = "match"
  visit "/users/#{@user.id}/match/#{@prospective_user.id}"
end

When("I skip the prospective user") do
  @current_action = "skip"
  page.driver.post "/users/#{@user.id}/skip/#{@prospective_user.id}"
end

When("I block the prospective user") do
  @current_action = "block"
  page.driver.post "/users/#{@user.id}/block/#{@prospective_user.id}"
end

Then("I should see a success message") do
  expect(page.status_code).to eq(200)
  
  success_messages = {
    "match" => "Matched successfully.",
    "skip" => "Skipped successfully.",
    "block" => "Blocked successfully."
  }
  
  expected_message = success_messages[@current_action]
  expect(JSON.parse(page.body)["message"]).to eq(expected_message)
end

And("a match should be created in the database") do
  expect(UserMatch.find_by(user_id: @user.id, prospective_user_id: @prospective_user.id, status: "matched")).to be_present
end

And("a skip record should be created in the database") do
  expect(UserMatch.find_by(user_id: @user.id, prospective_user_id: @prospective_user.id, status: "skipped")).to be_present
end

And("a block record should be created in the database") do
  expect(UserMatch.find_by(user_id: @user.id, prospective_user_id: @prospective_user.id, status: "blocked")).to be_present
end

When("I try to match with myself") do
  visit "/users/#{@user.id}/match/#{@user.id}"
end

Then("I should see an error message") do
  expect(page.status_code).to eq(422)
  error_message = JSON.parse(page.body)["error"]
  expect(error_message).to match(/You cannot (match|skip|block) yourself/)
end

Given("there is a prospective user who has matched with me") do
  @prospective_user = FactoryBot.create(:user, :complete_profile)
  UserMatch.create(user_id: @prospective_user.id, prospective_user_id: @user.id, status: "matched")
end

And("notifications should be created for both users") do
  expect(Notification.find_by(user: @user, matched_user: @prospective_user)).to be_present
  expect(Notification.find_by(user: @prospective_user, matched_user: @user)).to be_present
end

When("I try to skip myself") do
  page.driver.post "/users/#{@user.id}/skip/#{@user.id}"
end

When("I try to block myself") do
  page.driver.post "/users/#{@user.id}/block/#{@user.id}"
end

Given("the match will fail to save") do
  allow_any_instance_of(UserMatch).to receive(:save).and_return(false)
end

Given("the skip will fail to save") do
  allow_any_instance_of(UserMatch).to receive(:save).and_return(false)
end

Given("the block will fail to save") do
  allow_any_instance_of(UserMatch).to receive(:save).and_return(false)
end

Then("I should see a failure message") do
  expect(page.status_code).to eq(422)
  expect(JSON.parse(page.body)["error"]).to include("Failed to")
end

Given("there are multiple prospective users with various profiles") do
  # Set up the current user's fitness profile
  @user.fitness_profile.update!(
    age_range_start: 25,
    age_range_end: 35,
    gender_preferences: "Female,Non-binary",
    gym_locations: "Gym A,Gym B",
    activities_with_experience: "Running:Intermediate|Swimming:Beginner",
    workout_schedule: "Morning=06:00-08:00|Evening=18:00-20:00",
    workout_types: "Cardio,Strength"
  )

  # Create a matching user
  @matching_user = FactoryBot.create(:user, 
    age: 30, 
    gender: "Female",
    username: "MatchingUser"
  )
  @matching_user.fitness_profile.update!(
    age_range_start: 25,
    age_range_end: 35,
    gender_preferences: "Male,Non-binary",
    gym_locations: "Gym A",
    activities_with_experience: "Running:Advanced|Swimming:Intermediate",
    workout_schedule: "Morning=06:00-08:00",
    workout_types: "Cardio"
  )

  # Create a non-matching user
  @non_matching_user = FactoryBot.create(:user, 
    age: 40, 
    gender: "Male",
    username: "NonMatchingUser"
  )
  @non_matching_user.fitness_profile.update!(
    age_range_start: 35,
    age_range_end: 45,
    gender_preferences: "Female",
    gym_locations: "Gym C",
    activities_with_experience: "Yoga:Beginner",
    workout_schedule: "Afternoon=14:00-16:00",
    workout_types: "Flexibility"
  )

  # Create UserMatch entries
  UserMatch.create!(user_id: @user.id, prospective_user_id: @matching_user.id, status: "new")
  UserMatch.create!(user_id: @user.id, prospective_user_id: @non_matching_user.id, status: "new")
end

Then("the list should only include users matching my preferences") do
  response_body = JSON.parse(page.body)
  puts "Response body: #{response_body}"
  puts "Matching user ID: #{@matching_user.id}"
  puts "Non-matching user ID: #{@non_matching_user.id}"
  expect(response_body.length).to eq(1)
  expect(response_body.first["id"]).to eq(@matching_user.id)
end
