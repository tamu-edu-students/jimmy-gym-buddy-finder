Given("I am on the login page") do
  visit root_path # Assuming the root path serves the login page
end

Then("I should see the main heading") do
  expect(page).to have_selector("h1.main-heading", text: "Jimmy")
end

Then("I should see the subtitle") do
  expect(page).to have_selector("p.subtitle", text: "Find Your Gym Buddies Here!")
end

Then("I should see the login image") do
  expect(page).to have_selector("img.login-image[alt='Jimmy Logo']")
end

Then("I should see a button to log in") do
  expect(page).to have_button("Login with Google")
end

When("I click on {string}") do |button_name|
  click_button button_name
end

Then("I should be redirected to the Google sign-in page") do
  expect(page).to have_current_path(/accounts\.google\.com/) # Regex to check for Google sign-in URL
end

Then("I should see {string}") do |message|
  expect(page).to have_content(message)
end
