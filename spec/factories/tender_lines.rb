FactoryBot.define do
  factory :tender_line do
    tender
    product
    unit { 1 }
    observation { "MyText" }
  end
end
