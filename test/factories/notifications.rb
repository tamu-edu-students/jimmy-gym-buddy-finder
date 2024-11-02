FactoryBot.define do
  factory :notification do
    read { false }

    # Create associations for user and matched_user
    association :user
    association :matched_user, factory: :user  # Assuming matched_user is also a user
  end
end
