# features/step_definitions/profile_swipe_steps.rb

require 'rspec/expectations'
require 'rspec/mocks'

# In features/step_definitions/profile_swipe_steps.rb

Given("I am logged in as a user for profile swipe") do
    @user = FactoryBot.create(:user, :complete_profile)
    page.set_rack_session(user_id: @user.id)
  end

# In features/step_definitions/profile_swipe_steps.rb

When("I visit the profile swipe page") do
    allow(UserMatchesController).to receive(:get_prospective_users).and_return([
      { 'id' => 1, 'username' => 'user1', 'age' => 25, 'fitness_profile' => { 'activities_with_experience' => 'Running:Intermediate' } },
      { 'id' => 2, 'username' => 'user2', 'age' => 30, 'fitness_profile' => { 'activities_with_experience' => 'Swimming:Beginner' } }
    ])
    visit matching_profileswipe_path(@user.id)
  end

Then("I should see the profile swipe container") do
  expect(page).to have_css('.profile-cards')
end

And("I should see the action buttons") do
  expect(page).to have_css('button[onclick="handleAction(\'block\')"]')
  expect(page).to have_css('button[onclick="handleAction(\'skip\')"]')
  expect(page).to have_css('button[onclick="handleAction(\'like\')"]')
end
