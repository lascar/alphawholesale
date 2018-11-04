FactoryBot.define do
  factory :tender_line do
    tender { :tender }
    product { :product }
    unit { 1 }
    unit_type { "kilogram" }
    observation { "MyText" }
  end
end
