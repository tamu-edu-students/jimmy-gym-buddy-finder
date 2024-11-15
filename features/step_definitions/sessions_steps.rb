Given("I am not logged in") do
  page.set_rack_session(user_id: nil)
end

Given("I am logged in") do
  @user = FactoryBot.create(:user, :complete_profile)
  page.set_rack_session(user_id: @user.id)
end

Given('I am logged in as an non-configured user') do
  @user = FactoryBot.create(:user, :incomplete_profile)
  page.set_rack_session(user_id: @user.id)
end

Given('I am a well-configured user and not log in') do
  @user = FactoryBot.create(:user, :complete_profile)
  step "I am not logged in"
end

Given('I am a non-configured user and not log in') do
  @user = FactoryBot.create(:user, :incomplete_profile)
end

When('the authentication fails') do
  OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
end

When('I click {string}') do |link_text|
  click_link link_text
end

When("I click the {string} button") do |button_text|
  click_button button_text
end

When('I am on the welcome page') do
  visit welcome_path
end

When('I am on my dashboard page') do
  visit dashboard_user_path(@user)
end

Then("I should see the button {string}") do |button_text|
  expect(page).to have_button(button_text)
end

Then('I should see the profile message {string}') do |message|
  within("#flash") do
    expect(page).to have_content(message)
  end
end

Then("I should be redirected to my dashboard") do
  expect(page).to have_current_path(dashboard_user_path(@user))
end

Then("I should be redirected to edit profile page") do
  expect(page).to have_current_path(edit_user_path(@user))
end

Then("I should be redirected to the welcome page") do
  expect(page).to have_current_path(welcome_path)
end
