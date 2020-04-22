FactoryBot.define do
  factory :response do
    supplier
    concrete_product
    request
    quantity { 1 }
    unit_price_supplier { "9.99" }
    unit_price_broker { "9.99" }
    localisation_supplier { "MyString" }
    localisation_broker { "MyString" }
    incoterm { "MyString" }
    approved { false }
    supplier_observation { "MyText" }
  end
end
