FactoryBot.define do
  factory :offer do
    supplier
    product
    quantity { 1 }
    unit_price_supplier { 1 }
    unit_price_broker { 0 }
  end
end
