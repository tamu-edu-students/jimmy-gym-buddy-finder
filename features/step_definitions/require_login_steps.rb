# features/step_definitions/require_login_steps.rb

Given('I am on the protected page') do
  # Define the path to a protected page (e.g., a dashboard or a settings page)
  @protected_page_path = some_protected_path  # Replace with your actual protected page path
end

Given('I am not logged in') do
  # Make sure no user is logged in
  visit logout_path if defined?(logout_path)  # Log out if there’s a logout path defined
end

Given('I am logged in as a user') do
  @user = FactoryBot.create(:user)  # Use FactoryBot to create a user
  # Log in as the created user
  login_as(@user, scope: :user)  # Using Warden's test helpers if using Devise
end

When('I try to visit the protected page') do
  visit @protected_page_path
end

Then('I should be redirected to the welcome page') do
  expect(page).to have_current_path(welcome_path)  # Ensure you replace `welcome_path` with your actual welcome page path if different
end

Then('I should see {string}') do |message|
  expect(page).to have_content(message)
end

Then('I should see the protected page content') do
  # Check for some specific content that is only available on the protected page
  expect(page).to have_content('Protected Page Content')  # Replace with your actual protected page content
end

Then('I should not see {string}') do |message|
  expect(page).not_to have_content(message)
end
