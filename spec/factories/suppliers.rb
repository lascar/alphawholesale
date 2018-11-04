FactoryBot.define do
  factory :supplier do
    identifier { generate :identifier }
    email { generate :email }
    password { "password" }
    approved { true }
    tin { "heoduo" }
    country {"france"}
    entreprise_name { "entreprise name"}

    factory :supplier_with_offers do
      # offers_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        offers_count { 5 }
      end

      # the after(:create) yields two values; the supplier instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the supplier is associated properly to the offer
      after(:create) do |supplier, evaluator|
        create_list(:offer, evaluator.offers_count, supplier: supplier)
      end
    end
  end
end
