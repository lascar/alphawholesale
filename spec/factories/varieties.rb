FactoryBot.define do
  factory :variety do
    name { generate :name }
    product { nil }
  end
end
