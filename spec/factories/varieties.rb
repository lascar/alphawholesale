FactoryBot.define do
  factory :variety do
    sequence(:name) {|n| "Variety #{n}"}
  end
end
