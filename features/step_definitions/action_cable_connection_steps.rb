# features/step_definitions/action_cable_connection_steps.rb

Given("I am a valid user") do
    @user = User.create!(
      username: "testuser",
      email: "test@example.com",
      first_name: "First",
      last_name: "Last",
      age: 20,
      gender: "Male",
      school: "Texas A&M University, College Station",
      major: "Computer Science",
      about_me: "I am a test user.",
      uid: "123456", # Mock UID for testing
      provider: "google_oauth2" # Mock provider
    )
  end
  
  When("I connect to the Action Cable server") do
    # Using ActionCable's test helper to simulate a connection
    @connection = ActionCable::Channel::TestConnection.new(current_user: @user)
  end
  
  Then("I should receive a confirmation message of successful connection") do
    # Check if the connection is valid
    expect(@connection).to be_present
    expect(@connection.connected?).to be_truthy
  end
  