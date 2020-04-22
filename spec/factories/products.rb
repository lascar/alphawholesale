FactoryBot.define do
  factory :product do
    sequence(:name) {|n| "product_#{n}"}
    sequence(:assortments) { |n| {varieties: ["variety_test#{n}", "not_specified"],
                                  aspects: ["aspect_test#{n}", "not_specified"],
                                  packagings: ["packaging_test#{n}", "not_specified"],
                                  sizes: ["size_test#{n}", "not_specified"],
                                  calibers: ["calibre_test#{n}", "not_specified"]}}
  end
end
