FactoryBot.define do
  factory :size do
    sequence(:name) {|n| "Size #{n}"}
  end
end
