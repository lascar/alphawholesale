require 'rails_helper'

RSpec.describe Aspect, type: :model do
  before(:all) do
    @product1 = create(:product, variety: "variety1")
    @product2 = create(:product, variety: "variety2")
    @aspect1 = create(:aspect, product_id: @product1.id)
  end

  it "is valid if aspect is uniq in scope" do
    aspect2 = build(:aspect, name: @aspect1.name,
                                   product_id: @product2.id)
    expect(aspect2).to be_valid
  end

  it "is not valid if aspect is not uniq in scope" do
    aspect2 = build(:aspect, name: @aspect1.name,
                                   product_id: @product1.id)
    expect(aspect2).to_not be_valid
  end
end
