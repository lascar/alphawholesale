FactoryBot.define do
  factory :customer do
    identifier { generate :identifier }
    email { generate :email }
    password {"password"}
    approved { true }
    tin { "heoduo" }
    country {"france"}
    entreprise_name { "entreprise name"}
    unit_type { "kilogram" }
    currency { "euro" }

  end
end
