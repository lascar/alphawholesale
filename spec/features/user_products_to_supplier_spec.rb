require 'rails_helper'

# a supplier can have somme products of interest
# these products appears in a list of products for this supplier
RSpec.describe 'Suppliers Feature new', type: :feature do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:product3) {create(:product)}
  let(:supplier1) {create(:supplier, products: [product1.name, product2.name])}

  describe 'GET #attach_products' do

    # TEST as a supplier
    # TEST see a list of his products of interest
    # TEST and can choose and delete among the list of product
    describe 'as a supplier' do
      before :each do
        sign_in(supplier1)
      end

      it 'can create a new attached product' do
        visit supplier_path(supplier1)
        find('#user_products').click
        expect(page.find("#check_user_products_#{product1.name}").checked?).to be(true)
        expect(page.find("#check_user_products_#{product2.name}").checked?).to be(true)
        expect(page.find("#check_user_products_#{product3.name}").checked?).to be(false)
        page.find("#check_user_products_#{product2.name}").uncheck
        page.find("#check_user_products_#{product3.name}").check
        find('input[name="commit"]').click
        expect(page.find("#check_user_products_#{product1.name}").checked?).to be(true)
        expect(page.find("#check_user_products_#{product3.name}").checked?).to be(true)
        expect(page.find("#check_user_products_#{product2.name}").checked?).to be(false)
        expect(page).to have_content(I18n.t('controllers.user_products.update.succefully'))
      end
    end

  end
end
