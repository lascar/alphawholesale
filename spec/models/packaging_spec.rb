require 'rails_helper'

RSpec.describe Packaging, type: :model do
  before(:all) do
    @product1 = create(:product)
    @product2 = create(:product)
    @packaging1 = create(:packaging, product_id: @product1.id)
  end

  it "is valid packaging is uniq in scope" do
    packaging2 = build(:packaging, name: @packaging1.name,
                                   product_id: @product2.id)
    expect(packaging2).to be_valid
  end

  it "is not valid if packaging is not uniq in scope" do
    packaging2 = build(:packaging, name: @packaging1.name,
                                   product_id: @product1.id)
    expect(packaging2).to_not be_valid
  end
end
