FactoryBot.define do
  factory :packaging do
    name { generate :packaging }
    product { nil }
    supplier { nil }
  end
end
