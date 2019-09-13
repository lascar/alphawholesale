require 'rails_helper'

# a customer can have somme products attached
# these products appears in a list of attached products for this customer
RSpec.describe 'Customers Feature new', type: :feature do
  let(:product1) {create(:product, approved: true)}
  let!(:product2) {create(:product, approved: true)}
  let!(:product3) {create(:product, approved: true)}
  let!(:product4) {create(:product, approved: true)}
  let(:customer1) {create(:customer, products: [product1])}

  describe 'GET #attach_products' do

    # TEST as a customer
    # TEST when a list of product available is asked to be attached
    # TEST then a list of the attached product can be displayed
    describe 'as a customer' do
      before :each do
        sign_in(customer1)
      end

      xit 'assigns a new customer' do
        visit customer_path(customer1)
        find('#attached_products').click
        expect(page).to have_content(product1.name.capitalize)
        find('#new_attached_product').click
        save_and_open_page
        expect(page).to have_xpath("//form[@action='/attached_products'
                                   and @method='post']")
        expect(page.find("input#product_" + product1.id.to_s)).to be_checked
        expect(page.find("input#product_" + product4.id.to_s)).not_to be_checked
        find('input#attach_product' + product2.id.to_s).check
        find('input#attach_product' + product3.id.to_s).check
        find('[name=commit]').click
        expect(page.current_url).to eq(
          'http://www.example.com/attached_products/')
        expect(page).to have_content(supplier.email)
        expect(page).to have_field({id: 'product_' + product2.id.to_s})
        expect(page).to have_field({id: 'product_' + product3.id.to_s})
        expect(page).not_to have_field({id: 'product_' + product4.id.to_s})
        expect(page).to have_content(
          I18n.t('controllers.attach_product.successfully_attached'))
      end
    end

  end
end
