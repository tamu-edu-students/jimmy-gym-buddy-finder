FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    username { "JohnDoe" }
    age { 25 }
    gender { "Male" }
    uid { "12345" }
    provider { "google_oauth2" }
  end
end