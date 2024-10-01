# features/step_definitions/dashboard_navigation_steps.rb

Given("I am on the dashboard page") do
    visit dashboard_path
  end

  When("I enter the dashboard for the first time") do
    # First time?
  end

  Then("I should see introductions for each feature displayed on the screen") do
    expect(page).to have_content("Feature Introduction")
  end

  When("I click the {string} icon") do |icon_name|
    click_link icon_name
  end

  Then("I should be navigated to the User Profile Management page") do
    expect(current_path).to eq(profile_path)
  end
