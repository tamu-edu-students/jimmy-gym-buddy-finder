# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    username { "testuser" }
    first_name { "Test" }
    last_name { "User" }
    age { 25 }
    gender { "Other" }
    school { "University" }
    major { "Computer Science" }
    about_me { "I love coding." }
    uid { "12345" }
    provider { "google" }
    photo { "http://example.com/photo.jpg" }
  end
end
