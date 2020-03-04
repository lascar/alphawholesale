FactoryBot.define do
  factory :offer do
    supplier
    quantity { 1 }
    unit_price_supplier { 1 }
    unit_price_broker { 0 }
    attached_product {create(:attached_product, suppliers: [supplier])}
  end
end
