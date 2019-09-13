require 'rails_helper'

RSpec.describe AttachedProduct, type: :model do
  let(:product1) {create(:product, approved: true)}
  let(:product2) {create(:product, approved: false)}
  let(:customer1) {create(:customer)}

  it "can attach an approved product with a customer" do
    AttachedProduct.create(product_id: product1.id, attachable_type: "Customer", attachable_id: customer1.id)
    expect(customer1.products).to include(product1)
  end

  it "can not attach an non approved product with a customer" do
    AttachedProduct.create(product_id: product2.id, attachable_type: "Customer", attachable_id: customer1.id)
    expect(customer1.products).not_to include(product2)
  end
end
