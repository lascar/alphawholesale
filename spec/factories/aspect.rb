FactoryBot.define do
  factory :aspect do
    sequence(:name) {|n| "Aspect #{n}"}
  end
end
