FactoryBot.define do
  factory :product do
    sequence(:name) {|n| "Product #{n}"}
    approved { true }
  end
end
