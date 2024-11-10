FactoryBot.define do
  factory :message do
    content { "MyString" }
    private_chat { nil }
    profile { nil }
  end
end
