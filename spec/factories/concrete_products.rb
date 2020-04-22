FactoryBot.define do
  factory :concrete_product do
    sequence(:product) { |n| "product_test#{n}"}
    sequence(:variety) { |n| "variety_test#{n}"}
    sequence(:aspect) { |n| "aspect_test#{n}"}
    sequence(:packaging) { |n| "packaging_test#{n}"}
    sequence(:size) { |n| "size_test#{n}"}
    sequence(:caliber) { |n| "caliber_test#{n}"}
  end
end
