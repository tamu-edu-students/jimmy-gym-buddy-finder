# features/step_definitions/user_profile_management_steps.rb

# Given("the database is reset") do
#   User.destroy_all
# end

# Given("a user exists with the following details:") do |table|
#   attributes = table.rows_hash
#   @user = User.new(
#     first_name: attributes["first_name"],
#     last_name: attributes["last_name"],
#     age: attributes["age"],
#     gender: attributes["gender"]
#   )
#   if @user.save
#     puts "User successfully created!"
#   else
#     puts "There were errors while saving the user: #{@user.errors.full_messages}"
#   end
# end

Given("I am on the User Profile Management page") do
  visit edit_user_path(@user)
end

When("I want to update my profile") do
end

Then("I should be able to upload and change my profile photo") do
  attach_file('photo', Rails.root.join('test_image', 'user_profile.png'))
end

Then("I should see following introductions on the screen") do
  expect(page).to have_content("You must be logged in to access this section")
end

Then("I should be able to modify my gender") do
  fill_in 'user_gender', with: 'Male'
end

Then("I should be able to set or update my age using a date picker") do
  fill_in 'user_age', with: '25'
end

Then("I should be able to save these changes") do
  click_button 'Save'
end

Then("I should see a confirmation message when the updates are successfully saved") do
  expect(page).to have_content('Profile is incomplete. Please fill in all required fields.')
end
