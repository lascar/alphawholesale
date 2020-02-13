FactoryBot.define do
  factory :product do
    sequence(:name) {|n| "product_#{n}"}
    sequence(:assortments) { |n| {varieties: ["variety_test#{n}", "nil"],
                                  aspects: ["aspect_test#{n}", "nil"],
                                  packagings: ["packaging_test#{n}", "nil"],
                                  sizes: ["size_test#{n}", "nil"],
                                  calibers: ["calibre_test#{n}", "nil"]}}
  end
end
