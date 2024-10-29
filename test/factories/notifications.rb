FactoryBot.define do
  factory :notification do
    user { nil }
    matched_user { nil }
    message { "MyString" }
    read { false }
  end
end
