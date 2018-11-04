FactoryBot.define do
  factory :broker do
    identifier { generate :identifier }
    email { "broker1@test.com" }
    password {"password"}

  end
end
