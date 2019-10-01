require 'rails_helper'

# a customer can have somme products attached
# these products appears in a list of attached products for this customer
RSpec.describe 'Admin Attached Products Customers Feature', type: :feature do
  let!(:product1) {create(:product, approved: true)}
  let!(:product2) {create(:product, approved: true)}
  let!(:product3) {create(:product, approved: true)}
  let!(:broker1) {create(:broker, products: [product1, product2, product3])}
  let!(:customer1) {create(:customer, products: [product1])}
  let!(:customer2) {create(:customer, products: [product2, product3])}

  describe 'GET #attach_products' do

    # TEST as a broker
    # TEST when a list of attached product to customers is asked for
    # TEST then a list of the attached product to customer is displayed
    describe 'as a broker' do
      before :each do
        sign_in(broker1)
      end

      it 'asks for a list of attached products to customers' do
        visit admin_attached_products_path(search: {type: 'customer'})
        attached_product1 = AttachedProduct.where(product_id: product1.id,
                                                  attachable_id: customer1.id,
                                                  attachable_type: 'Customer').first
        id = 'Customer_' + customer1.id.to_s + '_' + attached_product1.id.to_s
        expect(page).to have_selector("tr##{id}")
        attached_product2 = AttachedProduct.where(product_id: product2.id,
                                                  attachable_id: customer2.id,
                                                  attachable_type: 'Customer').first
        id = 'Customer_' + customer2.id.to_s + '_' + attached_product2.id.to_s
        expect(page).to have_selector("tr##{id}")
        attached_product3 = AttachedProduct.where(product_id: product3.id,
                                                  attachable_id: customer2.id,
                                                  attachable_type: 'Customer').first
        id = 'Customer_' + customer2.id.to_s + '_' + attached_product3.id.to_s
        expect(page).to have_selector("tr##{id}")
      end
    end

  end
end
