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
    gender: attributes["gender"],
    email: attributes["email"],
    uid: SecureRandom.hex(10),
    provider: "google"
  )
  if @user.save
    puts "User successfully created!"
  else
    puts "There were errors while saving the user: #{@user.errors.full_messages}"
  end
end

  Given("I am on the dashboard page") do
    @user = User.find_by(first_name: "TestUser") 
    if @user.nil?
      raise "User not found"
    end
    visit dashboard_user_path(@user) 
  end

  When("I enter the dashboard for the first time") do
    # First time?
  end

  Then("I should see introductions for each feature displayed on the screen") do
    expect(page).to have_content("You must be logged in to access this section")
  end

  When("I click the Profile icon") do
    click_link "Profile"
  end

  Then("I should be navigated to the User Profile Management page") do
    expect(current_path).to eq(profile_user_path(@user))
  end
