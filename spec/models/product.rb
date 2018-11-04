# spec/models/product_spec.rb
require "rails_helper"

RSpec.describe Product, :type => :model do

  before(:all) do
    @product1 = create(:product)
  end

  it "is valid with valid attributes" do
    expect(@product1).to be_valid
  end

  it "is valid if the name is uniq with scope" do
    product2 = build(:product, name: @product1.name)
    expect(product2).to be_valid
  end
end
