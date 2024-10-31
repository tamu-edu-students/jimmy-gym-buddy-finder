FactoryBot.define do
  factory :user do
    uid { "123456789" }
    provider { "google_oauth2" }
    sequence(:email) { |n| "user#{n}@example.com" }
    username { 'TestUser' }
    age { 30 }
    gender { "Male" }

    trait :complete_profile do
      after(:create) do |user, evaluator|
        create(:fitness_profile, user: user)
      end
    end

    trait :incomplete_profile do
      username { nil }
      age { nil }
      gender { nil }
    end
  end
end