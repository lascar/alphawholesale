FactoryBot.define do
  factory :user_product do
    user { nil }
    product { nil }
    conditions { "" }
    mailing { false }
  end
end
