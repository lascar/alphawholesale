require 'rails_helper'

# a customer can have somme products attached
# these products appears in a list of attached products for this customer
RSpec.describe 'Customers Feature new', type: :feature do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let(:variety1) {product2.assortments["varieties"].first}
  let(:aspect1) {product2.assortments["aspects"].first}
  let(:packaging1) {product2.assortments["packagings"].first}
  let(:size1) {product2.assortments["sizes"].first}
  let(:caliber1) {product2.assortments["calibers"].first}
  let(:customer1) {create(:customer, products: [product1, product2])}
  let!(:concrete_product1) {create(:concrete_product, customers: [customer1],
                                   product: product1.name)}

  describe 'GET #attach_products' do

    # TEST as a customer
    # TEST see a list of his attached products
    # TEST and can create a new one
    describe 'as a customer' do
      before :each do
        sign_in(customer1)
      end

      it 'can create a new attached product' do
        visit customer_path(customer1)
        find('#concrete_products').click
        expect(page).to have_selector(
          "#concrete_product_variety_#{concrete_product1[:id].to_s}")
        expect(customer1.concrete_products.count).to eq(1)
        within("#form_new_attach_product") do
					select product2.name
					find('input[name="commit"]').click
        end
        expect(page).to have_content(I18n.t("products." + product2.name + ".name"))
        within("#radios_varieties") do
          choose "concrete_product[variety]_" + variety1
        end
        within("#radios_aspects") do
          choose "concrete_product[aspect]_" + aspect1
        end
        within("#radios_packagings") do
          choose "concrete_product[packaging]_" + packaging1
        end
        within("#radios_sizes") do
          choose "concrete_product[size]_" + size1
        end
        within("#radios_calibers") do
          choose "concrete_product[caliber]_" + caliber1
        end
				find('input[name="commit"]').click
        expect(customer1.concrete_products.count).to eq(2)
        new_concrete_product = ConcreteProduct.last
        expect(page).to have_selector(
          "#concrete_product_variety_#{new_concrete_product[:id].to_s}")
        expect(page.current_url).to eq(
          "http://www.example.com/customers/#{customer1.id.to_s}/concrete_products")
        expect(page).to have_content(
        I18n.t('controllers.concrete_products.create.succefully'))
      end
    end

  end
end
