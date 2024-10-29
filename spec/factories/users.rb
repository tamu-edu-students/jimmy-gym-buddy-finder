FactoryBot.define do
  factory :user do
    uid { "123456789" }
    provider { "google_oauth2" }
    sequence(:email) { |n| "user#{n}@example.com" } 

    trait :complete_profile do
      username { 'TestUser' }
      age { 25 }
      gender { 'Male' }
    end

    trait :incomplete_profile do
      username { nil }
      age { nil }
      gender { nil }
    end
  end
end
