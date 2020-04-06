FactoryBot.define do
  factory :offer do
    supplier
    quantity { 1 }
    unit_price_supplier { 1 }
    unit_price_broker { 0 }
    concrete_product {create(:concrete_product, suppliers: [supplier])}
  end
end
