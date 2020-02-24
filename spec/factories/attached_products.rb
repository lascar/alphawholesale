FactoryBot.define do
  factory :attached_product do
    product {"product_test"} 
    sequence(:definition) { |n| {variety: "variety_test#{n}", aspect: "aspect_test#{n}", packaging: "packaging_test#{n}", size: "size_test#{n}", caliber: "calibre_test#{n}"}}
  end
end
