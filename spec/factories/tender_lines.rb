FactoryBot.define do
  factory :tender_line do
    tender { :tender }
    product { :product }
    unit { 1 }
    observation { "MyText" }
  end
end
