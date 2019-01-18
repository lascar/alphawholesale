FactoryBot.define do
  factory :customer do
    sequence(:identifier) {|n| "Customer #{n}"}
    sequence(:email) {|n| "customer#{n}@example.com"}
    password {"password"}
    approved { true }
    tin { "heoduo" }
    country {"france"}
    entreprise_name { "entreprise name"}
    unit_type { "kilogram" }
    currency { "euro" }

  end
end
