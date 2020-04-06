require 'rails_helper'

# a supplier can have somme products attached
# these products appears in a list of attached products for this supplier
RSpec.describe 'Suppliers Feature new', type: :feature do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let(:variety1) {product2.assortments["varieties"].first}
  let(:aspect1) {product2.assortments["aspects"].first}
  let(:packaging1) {product2.assortments["packagings"].first}
  let(:size1) {product2.assortments["sizes"].first}
  let(:caliber1) {product2.assortments["calibers"].first}
  let!(:attached_product1) {create(:attached_product, product: product1.name, variety: variety1, aspect: aspect1, packaging: packaging1, size: size1, caliber: caliber1)}
  let!(:attached_product2) {create(:attached_product, product: product2.name, variety: variety1, aspect: aspect1, packaging: packaging1, size: size1, caliber: caliber1)}
  let(:supplier1) {create(:supplier, products: [product1, product2])}

  describe 'GET #attach_products' do

    # TEST as a supplier
    # TEST see a list of his attached products
    # TEST and can create a new one
    describe 'as a supplier' do
      before :each do
        supplier1.attached_products << attached_product1
        sign_in(supplier1)
      end

      it 'can create a new attached product' do
        visit supplier_path(supplier1)
        find('#attached_products').click
        expect(page).to have_selector(
          "#attached_product_variety_#{attached_product1[:id].to_s}")
        expect(supplier1.attached_products.count).to eq(1)
        within("#form_new_attach_product") do
					select product2.name
					find('input[name="commit"]').click
        end
        expect(page).to have_content(I18n.t("products." + product2.name + ".name"))
        expect(page).to have_xpath("//form[@action='/suppliers/" +
          supplier1.id.to_s + "/attached_products/' and @method='post']")
        within("#radios_varieties") do
          choose "attached_product[variety]_" + variety1
        end
        within("#radios_aspects") do
          choose "attached_product[aspect]_" + aspect1
        end
        within("#radios_packagings") do
          choose "attached_product[packaging]_" + packaging1
        end
        within("#radios_sizes") do
          choose "attached_product[size]_" + size1
        end
        within("#radios_calibers") do
          choose "attached_product[caliber]_" + caliber1
        end
				find('input[name="commit"]').click
        expect(supplier1.attached_products.count).to eq(2)
        new_attached_product = AttachedProduct.last
        expect(page).to have_selector(
          "#attached_product_variety_#{new_attached_product[:id].to_s}")
        expect(page.current_url).to eq(
          "http://www.example.com/suppliers/#{supplier1.id.to_s}/attached_products")
        expect(page).to have_content(
        I18n.t('controllers.attached_products.create.succefully'))
      end
    end

  end
end
