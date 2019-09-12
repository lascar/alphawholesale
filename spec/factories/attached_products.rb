FactoryBot.define do
  factory :attached_product do
    product
    variety { nil }
    aspect { nil }
    packaging { nil }
    attachable { nil }
  end
end
