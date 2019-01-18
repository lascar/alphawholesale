FactoryBot.define do
  factory :broker do
    sequence(:identifier) {|n| "Broker #{n}"}
    sequence(:email) {|n| "broker#{n}@example.com"}
    password {"password"}

  end
end
