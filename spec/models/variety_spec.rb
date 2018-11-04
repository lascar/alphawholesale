require 'rails_helper'

RSpec.describe Variety, type: :model do
  before(:all) do
    @product1 = create(:product, variety: "variety1")
    @product2 = create(:product, variety: "variety2")
    @variety1 = create(:variety, product_id: @product1.id)
  end

  it "is valid if variety is uniq in scope" do
    variety2 = build(:variety, name: @variety1.name,
                                   product_id: @product2.id)
    expect(variety2).to be_valid
  end

  it "is not valid if variety is not uniq in scope" do
      variety2 = build(:variety, name: @variety1.name,
                                   product_id: @product1.id)
    expect(variety2).to_not be_valid
  end
end
