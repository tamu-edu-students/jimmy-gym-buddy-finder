FactoryBot.define do
    factory :user_match do
      user
      association :prospective_user, factory: :user
      status { "new" }
    end
  end
