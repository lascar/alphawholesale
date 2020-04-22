FactoryBot.define do
  factory :request do
    customer
    quantity { 1 }
    concrete_product {create(:concrete_product, customers: [customer])}
  end
end
