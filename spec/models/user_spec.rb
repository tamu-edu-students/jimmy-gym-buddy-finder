require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { 
    User.new(
      email: "test@example.com",
      username: "testuser",
      first_name: "Test",
      last_name: "User",
      age: 25,
      gender: "Other",
      school: "University",
      major: "Computer Science",
      about_me: "I love coding.",
      uid: "12345", # For OAuth
      provider: "google" # For OAuth
    ) 
  }

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "is invalid without an email" do
    user.email = nil
    expect(user).to_not be_valid
  end

  it "is invalid without a username on profile update" do
    user.username = nil
    expect(user).to_not be_valid(:profile_update)
  end
end
