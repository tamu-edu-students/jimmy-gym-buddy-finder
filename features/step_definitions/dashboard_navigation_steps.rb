# features/step_definitions/dashboard_navigation_steps.rb
Given("the database is reset") do
  User.destroy_all
end

Given("a user exists with the following details:") do |table|
  attributes = table.rows_hash
  @user = User.new(
    first_name: attributes["first_name"],
    last_name: attributes["last_name"],
    age: attributes["age"],
    gender: attributes["gender"]
  )
  if @user.save
    puts "User successfully created!"
  else
    puts "There were errors while saving the user: #{@user.errors.full_messages}"
  end
end

Given("I am on the dashboard page") do
    visit dashboard_user_path(@user)
  end

  When("I enter the dashboard for the first time") do
    # First time?
  end

  Then("I should see introductions for each feature displayed on the screen") do
    expect(page).to have_content("Here are the features of the dashboard.")
  end

  When("I click the Profile icon") do
    click_link "Profile"
  end

  Then("I should be navigated to the User Profile Management page") do
    expect(current_path).to eq(profile_user_path(@user))
  end
