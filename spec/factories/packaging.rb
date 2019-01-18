FactoryBot.define do
  factory :packaging do
    sequence(:name) {|n| "Packaging #{n}"}
  end
end
