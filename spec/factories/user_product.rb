FactoryBot.define do
  factory :user_product do
    user {create(:supplier)}
  end
end
