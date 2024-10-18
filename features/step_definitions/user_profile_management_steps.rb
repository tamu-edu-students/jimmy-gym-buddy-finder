# features/step_definitions/user_profile_management_steps.rb

When("I am on the User Profile Management page") do
  visit edit_user_path(@user)
end

Then('I should be able to access my user profile') do
  find('a.btn', text: 'Profile').click
end

Then('I should see my user profile') do
  expect(page).to have_content('User Profile')
end

Then('I should be able to edit my user profile') do
  find('a.btn', text: 'Edit Profile').click
end

Then("I should be able to upload and change my profile photo") do
  attach_file('photo-upload', Rails.root.join('test_image', 'user_profile.png'))
end

Then('I should be able to change my user name') do
  fill_in 'username', with: 'TestName'
end

Then('I should be able to modify my gender') do
  select 'male', from: 'user_gender'
end

Then("I should be able to set or update my age using a date picker") do
  fill_in 'age', with: '25'
end

Then("I should be able to modify my school") do
  select "Texas A&M University, College Station", from: "user_school"
end

Then("I should be able to modify my major") do
  select "Computer Science", from: "user_major"
end

Then('I should be able to modify about me') do
  fill_in 'user_about_me', with: 'Test Test Test'
end

Then("I should be able to save these changes") do
  click_button 'Update Profile'
end

Then("I should see a confirmation message when the updates are successfully saved") do
  expect(page).to have_content('Profile successfully updated and is complete!')
end

When('I try to upload photo with invalid format and save') do
  attach_file('photo-upload', Rails.root.join('test_image', 'wrong_format.txt'))
  click_button 'Update Profile'
end

When('I should see error message of invalid photo format') do
  expect(page).to have_content('Photo must be a JPEG, JPG, GIF, or PNG.')
end

When('I try to upload photo with invalid size and save') do
  attach_file('photo-upload', Rails.root.join('test_image', 'too_large.jpg'))
  click_button 'Update Profile'
end

When('I should see error message of invalid photo size') do
  expect(page).to have_content('Photo must be less than 500KB in size.')
end

When('I try to leave my username blank and save') do
  fill_in 'username', with: ''
  click_button 'Update Profile'
end

Then('I should see error message of incomplete user profile') do
  expect(page).to have_content('Profile is incomplete. Please fill in all required fields.')
end

