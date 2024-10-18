# features/step_definitions/fitness_profile_management_steps.rb

Then('I should be able to create a fitness profile') do
  expect(page).to have_selector('a.icon-button', text: 'Create Fitness Profile')
end

When("I click the create fitness profile icon") do
  find('a.icon-button', text: 'Fitness').click
end

Then('I should be able to modify my fitness goals') do
  fill_in 'fitness_profile_fitness_goals', with: 'Lose weight'
end

Then('I should be able to modify my workout types') do
  fill_in 'fitness_profile_workout_types', with: 'Running'
end

Then('I should be able to select gender to match') do
  select 'Male', from: 'fitness_profile_gender'
end

Then('I should be able to select age range to match') do
  select '18', from: 'fitness_profile_age_range_start'
  select '28', from: 'fitness_profile_age_range_end'
end

Then('I should be able to save the fitness profile') do
  click_button 'Create Fitness Profile'
end

Then('I should see the confirm message when the fitness profile is created successfully') do
  expect(page).to have_content('Fitness profile created successfully.')
end

Given('I have created my fitness profile') do
  visit dashboard_user_path(@user)
  find('a.icon-button', text: 'Fitness').click
  fill_in 'fitness_profile_fitness_goals', with: 'Lose weight'
  fill_in 'fitness_profile_workout_types', with: 'Running'
  select 'Male', from: 'fitness_profile_gender'
  select '18', from: 'fitness_profile_age_range_start'
  select '28', from: 'fitness_profile_age_range_end'
  click_button 'Create Fitness Profile'
end

When('I am on my fitness page') do
  visit user_fitness_profile_path(@user)
end

When('I should see my fitness profile') do
  expect(page).to have_content('Fitness Profile')
end

Then('I should able to edit my fitness profile') do
  click_link 'Edit'
end

Then('I should be able to change my fitness goals') do
  fill_in 'fitness_profile_fitness_goals', with: 'Get stronger'
end

Then('I should be able to change my workout types') do
  fill_in 'fitness_profile_workout_types', with: 'strengh training'
end

Then('I should be able to change gender to match') do
  select 'Female', from: 'fitness_profile_gender'
end

Then('I should be able to change age range to match') do
  select '20', from: 'fitness_profile_age_range_start'
  select '25', from: 'fitness_profile_age_range_end'
end

Then('I should be able to save these updates') do
  click_button 'Update Fitness Profile'
end

Then('I should see the confirm message when the fitness profile is updated successfully') do
  expect(page).to have_content('Fitness profile updated successfully.')
end
