Then("I should be able to create a fitness profile") do
  expect(page).to have_css("a.badge.bg-warning.text-dark.p-3", text: "Create Fitness Profile")
end

When("I click the create fitness profile icon") do
  find('a.badge.bg-warning.text-dark.p-3', text: 'Fitness').click
end

Then('I should be able to select gender to match') do
  find("#genderButton").click
  check 'Male'
  check 'Female'
  find("#genderButton").click
end

Then('I should be able to select age range to match') do
  select '18', from: 'fitness_profile_age_range_start'
  select '28', from: 'fitness_profile_age_range_end'
end

Then('I should be able to select gym locations to match') do
  find("#gymLocationButton").click
  check('Student Rec Center')
  check('Polo Road Rec Center')
  check('Omar Smith Tennis Center')
  expect(page).to have_checked_field('Student Rec Center')
  expect(page).to have_checked_field('Polo Road Rec Center')
  expect(page).to have_checked_field('Omar Smith Tennis Center')
  find("#gymLocationButton").click
end

# Steps for selecting activity and experience
When('I select {string} as the preferred activity') do |activity|
  select activity, from: 'activitySelect'
end

When('I select {string} as the experience level') do |experience|
  select experience, from: 'experienceSelect'
end

When('I add the activity to my list') do
  find('.add-button-activity').click
end

Then('I should see {string} in my activity list') do |activity_with_experience|
  within('#activityList') do
    expect(page).to have_content(activity_with_experience)
  end
end

# Steps for selecting a workout day and adding to schedule
When('I select {string} as the workout day') do |day|
  select day, from: 'daySelect'
end

Then('I should see {string} in my workout schedule list') do |day|
  within('#schedulesList') do
    expect(page).to have_content(day)
  end
end

When('I select {string} as the preferred workout type') do |type|
  select type, from: 'workoutTypeSelect'
end

When('I add the workout type to my list') do
  find('.add-button-workout').click
end

Then('I should see {string} in my workout type list') do |type|
  within('#workoutTypeList') do
    expect(page).to have_content(type)
  end
end

Then('I should be able to save the fitness profile') do
  click_button 'Create Fitness Profile'
end

Then('I should see the confirm message when the fitness profile is created successfully') do
  expect(page).to have_content('Fitness profile created successfully.')
end

And('I have created my fitness profile') do
  find('a.badge.bg-warning.text-dark.p-3', text: 'Fitness').click

  find("#genderButton").click
  check 'Male'
  check 'Female'
  find("#genderButton").click

  select '18', from: 'fitness_profile_age_range_start'
  select '28', from: 'fitness_profile_age_range_end'

  find("#gymLocationButton").click
  check 'Student Rec Center'
  check 'Polo Road Rec Center'
  find("#gymLocationButton").click

  select 'Soccer', from: 'activitySelect'
  select 'Amateur', from: 'experienceSelect'
  find('.add-button-activity').click

  select 'Monday', from: 'daySelect'

  select 'Cardio', from: 'workoutTypeSelect'
  find('.add-button-workout').click
  click_button 'Create Fitness Profile'
end

When('I press the {string} button') do |button_text|
  click_link(button_text)
end

When('I update the gender preferences to {string} only') do |gender|
  find("#genderButton").click
  uncheck 'Male' if page.has_checked_field?('Male')
  check(gender)
  find("#genderButton").click
end

When('I submit the form') do
  click_button 'Update Fitness Profile'
end

Then('I should see the message {string}') do |message|
  expect(page).to have_content(message)
end

Then('I should see {string} as the selected gender preference') do |gender|
  within('li.list-group-item.bg-transparent.text-dark', text: 'Buddy Gender Preference') do
    expect(page).to have_content("Buddy Gender Preference: #{gender}")
  end
end

And("I click the create fitness profile") do
  find('a.badge.bg-warning.text-dark.p-3', text: 'Fitness').click
end

And('I select age range from {string} to {string}') do |min_age, max_age|
  select min_age, from: 'fitness_profile_age_range_start'
  select max_age, from: 'fitness_profile_age_range_end'
end

When('I submit the form without selecting other columns') do
  click_button 'Create Fitness Profile'
end

Then('I should see {string} in the gender feedback') do |feedback_gender|
  within('#genderFeedback') do
    expect(page).to have_content(feedback_gender)
  end
end

Then('I should see {string} in the age feedback') do |feedback_age|
  within('#ageFeedback') do
    expect(page).to have_content(feedback_age)
  end
end

