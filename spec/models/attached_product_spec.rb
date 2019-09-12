require 'rails_helper'

RSpec.describe AttachedProduct, type: :model do
  let(:product1) {create(:product, approved: true)}
  let(:product2) {create(:product, approved: true)}
  let(:product3) {create(:product, approved: false)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let!(:boker_attached_product) {create(:attached_product, product_id: product1.id,
                                       attachable_type: "Broker", attachable_id: broker1.id)}
  it "can attach an approved product with a broker" do
    AttachedProduct.create(product_id: product2.id, attachable_type: "Broker", attachable_id: broker1.id)
    expect(broker1.products).to include(product2)
  end

  it "can attach an approved and attachable product with a supplier" do
    AttachedProduct.create(product_id: product1.id, attachable_type: "Supplier", attachable_id: supplier1.id)
    expect(supplier1.products).to include(product1)
  end

  it "can attach an approved and attachable product with a customer" do
    AttachedProduct.create(product_id: product1.id, attachable_type: "Customer", attachable_id: customer1.id)
    expect(customer1.products).to include(product1)
  end

  it "can not attach an approved but not attachable product with a customer" do
    attached_product = AttachedProduct.create(product_id: product2.id, attachable_type: "Customer", attachable_id: customer1.id)
    expect(attached_product.errors.messages[:base]).to eq([I18n.t('activerecord.errors.models.attached_product.not_attachable')])
  end

  it "can not attach an non approved and not attachable product with a customer" do
    attached_product = AttachedProduct.create(product_id: product3.id, attachable_type: "Customer", attachable_id: customer1.id)
    expect(attached_product.errors.messages[:base]).to match_array([I18n.t('activerecord.errors.models.attached_product.product.not_approved', product: product3.name), I18n.t('activerecord.errors.models.attached_product.not_attachable')])
  end
end
