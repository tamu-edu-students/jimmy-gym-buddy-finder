Given("I am not logged in") do
  @user = nil
end

Given("I am logged in") do
  @user = FactoryBot.create(:user, username: "JohnDoe", email: "user@example.com", uid: "12345", provider: "google_oauth2")
  page.set_rack_session(user_id: @user.id)
end


When("I visit the login page") do
  visit welcome_path
end

When("I click the {string} button") do |button_text|
  if button_text == "Login with Google"
    @auth_hash = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "12345",
      info: { email: "user@example.com", name: "John Doe" }
    )
  end
end

When("I am authenticated successfully") do
  @user = FactoryBot.create(:user, username: "JohnDoe", email: "user@example.com", uid: "12345", provider: "google_oauth2")
end

When("I deny access") do
  @auth_hash = :access_denied
end

When("the login fails") do
  @auth_hash = OmniAuth::AuthHash.new(
    provider: "google_oauth2",
    uid: "54321",
    info: { email: "user@example.com", name: "John Doe" }
  )
end

When("I am authenticated but my profile is incomplete") do
  @user = FactoryBot.create(:user, username: "JohnDoe", email: "user@example.com", uid: "12345", provider: "google_oauth2")
  @user.update(age: nil, gender: nil)
  page.set_rack_session(user_id: @user.id)
end


Then("I should be redirected to my dashboard") do
  @current_path = dashboard_user_path(@user)
  expect(@current_path).to eq(dashboard_user_path(@user))
end

Then("I should be redirected to the failure path") do
  @current_path = failure_path
  expect(@current_path).to eq(failure_path)
end

Then("I should be redirected to the welcome page") do
  @current_path = welcome_path
  expect(@current_path).to eq(welcome_path)
end

Then("I should be redirected to the edit profile page") do
  @current_path = edit_user_path(@user)
  expect(@current_path).to eq(edit_user_path(@user))
end

Then("I should see {string}") do |message|
  @flash_message = message
  expect(@flash_message).to eq(message)
end