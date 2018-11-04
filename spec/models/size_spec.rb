require 'rails_helper'

RSpec.describe Size, type: :model do
  before(:all) do
    @product1 = create(:product)
    @product2 = create(:product)
    @size1 = create(:size, product_id: @product1.id)
  end

  it "is valid if size is uniq in scope" do
    size2 = build(:size, name: @size1.name,
                         product_id: @product2.id)
    expect(size2).to be_valid
  end

  it "is not valid if size is not uniq in scope" do
    size2 = build(:size, name: @size1.name,
                         product_id: @product1.id)
    expect(size2).to_not be_valid
  end
end
